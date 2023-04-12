import boto3
import time
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_ansible_runner_instance_id():
    ec2 = boto3.client('ec2')
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['ansible-runner']
            },
            {
                'Name': 'instance-state-name',
                'Values': ['stopped', 'running']
            }
        ]
    )

    instances = []
    for reservation in response['Reservations']:
        instances.extend(reservation['Instances'])

    if len(instances) == 0:
        raise Exception("No instance found with the 'ansible-runner' tag")
    elif len(instances) > 1:
        raise Exception("Multiple instances found with the 'ansible-runner' tag")

    return instances[0]['InstanceId']

def wait_for_ssm_instance_online(instance_id, max_retries=30, sleep_interval=10):
    ssm = boto3.client('ssm')
    retries = 0
    while retries < max_retries:
        response = ssm.describe_instance_information(
            InstanceInformationFilterList=[
                {
                    'key': 'InstanceIds',
                    'valueSet': [instance_id]
                }
            ]
        )
        if response['InstanceInformationList'] and response['InstanceInformationList'][0]['PingStatus'] == 'Online':
            return
        time.sleep(sleep_interval)
        retries += 1
    raise Exception("Instance did not become online in SSM")

def lambda_handler(event, context):
    try:
        logger.info('Getting instance ID')
        instance_id = get_ansible_runner_instance_id()
        logger.info(f'Ansible runner instance ID: {instance_id}')

        ssm_document_name = 'run_ansible_playbook'
        ec2 = boto3.client('ec2')
        ssm = boto3.client('ssm')

        logger.info('Starting instance')
        ec2.start_instances(InstanceIds=[instance_id])
        waiter = ec2.get_waiter('instance_running')
        waiter.wait(InstanceIds=[instance_id])
        logger.info('Instance started')

        logger.info('Waiting for instance to be online in SSM')
        wait_for_ssm_instance_online(instance_id)
        logger.info('Instance is online in SSM')

        logger.info('Executing Ansible playbook using SSM Run Command')
        commands = ['ansible-playbook /ansible/destroy.yaml']
        logger.info(f'Ansible playbook commands: {commands}')
        response = ssm.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            Parameters={
                'commands': commands
            },
            TimeoutSeconds=600
        )

        # Wait for the command execution to complete
        command_id = response['Command']['CommandId']
        logger.info(f'SSM command ID: {command_id}')
        logger.info('Waiting for command execution to complete')
        ssm.get_waiter('command_executed').wait(CommandId=command_id, InstanceId=instance_id)
        logger.info('Command execution complete')

        logger.info('Stopping instance')
        ec2.stop_instances(InstanceIds=[instance_id])
        logger.info('Instance stopped')
    except Exception as e:
        logger.error(f'Error occurred: {str(e)}')

if __name__ == '__main__':
    lambda_handler(None, None)