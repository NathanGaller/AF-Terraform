#!/bin/bash

sudo apt-get update

sudo apt-get install -y python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install boto3

export AWS_ACCESS_KEY_ID='${access_key}'
export AWS_SECRET_ACCESS_KEY='${secret_key}'
export AWS_REGION='${aws_region}'

sudo snap refresh amazon-ssm-agent

sudo snap start --enable amazon-ssm-agent

sudo apt-get install -y git


echo '${private_key}' > /home/ubuntu/.ssh/id_rsa
echo '${ansible_key}' > /home/ubuntu/.ssh/ansible

sudo chmod 600 /home/ubuntu/.ssh/id_rsa
sudo chmod 600 /home/ubuntu/.ssh/ansible

cd /home/ubuntu/

python3 -m pip install --user ansible
PATH=$PATH:~/.local/bin
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.general

export GIT_SSH_COMMAND="ssh -i /home/ubuntu/.ssh/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

sudo git clone --branch feature/CC-141-ansible-playbooks git@git1.smoothstack.com:cohorts/2022/organizations/cyber-cumulus/nathan-galler/ansible.git 

cd /home/ubuntu/ansible

envsubst < ec2_inventory.yaml | sudo tee ec2_inventory.yaml

