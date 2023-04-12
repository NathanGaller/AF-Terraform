import boto3
import json
import time

def lambda_handler(event, context):
    # Retrieve the cluster name from the input event
    cluster_name = event.get('cluster_name')

    # Initialize an EKS client
    eks_client = boto3.client('eks')

    # Retrieve the list of nodegroup names
    nodegroup_names = eks_client.list_nodegroups(clusterName=cluster_name)['nodegroups']

    # Update the scaling configuration for each nodegroup to set the desired capacity to 0
    for nodegroup_name in nodegroup_names:
        try:
            eks_client.update_nodegroup_config(
                clusterName=cluster_name,
                nodegroupName=nodegroup_name,
                scalingConfig={
                    'desiredSize': 0,
                    'maxSize': 0,
                    'minSize': 0
                }
            )
        except Exception as e:
            return {
                'statusCode': 500,
                'body': json.dumps(f'Error updating scaling config for nodegroup {nodegroup_name} in EKS cluster {cluster_name}: {e}')
            }

    return {
        'statusCode': 200,
        'body': json.dumps(f'EKS cluster {cluster_name} disabled.')
    }