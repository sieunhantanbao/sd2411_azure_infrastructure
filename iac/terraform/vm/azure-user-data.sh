#! /bin/bash
####################################INSTALL DOCKER###############################################
# Update the apt package index and install packages to allow apt to use a repository over HTTPS
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

# The following command is to set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" 

# Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version
sudo apt update 
sudo apt install -y docker-ce

# To run docker without sudo
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker $USER

#####################################INSTALL JENKINS############################################################
sudo apt update
# Install java11
sudo apt install openjdk-11-jdk -y
# Add Jenkins Repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install jenkins -y

# Modify Firewall to Allow Jenkins
sudo ufw allow 8080
sudo ufw status
sudo ufw enable
