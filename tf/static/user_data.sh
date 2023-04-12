#!/bin/bash

# Update package list and install necessary dependencies
sudo apt-get update

# Install AWS CLI and SSM Agent
sudo apt-get install -y python3-pip
sudo pip3 install awscli

# Download and install the latest version of the Amazon SSM Agent
sudo snap refresh amazon-ssm-agent

# Enable and start the SSM Agent
sudo snap start --enable amazon-ssm-agent

# Install git and clone ansible project
sudo apt-get install -y git
git clone https://git1.smoothstack.com/cohorts/2022/organizations/cyber-cumulus/nathan-galler/ansible.git
