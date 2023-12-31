#! /bin/bash
##########################INSTALL DOCKER#####################################################3
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

# The following command is to set up the stable repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` stable" -y

# Update the apt package index, and install the latest version of Docker Engine and containerd, or go to the next step to install a specific version
sudo apt update 
sudo apt install -y docker-ce

# To run docker without sudo
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo usermod -a -G docker jenkins
###############################INSTALL JENKINS########################################

sudo apt-get update
sudo apt install openjdk-11-jdk -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]  https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins

# Modify Firewall to Allow Jenkins
sudo ufw allow 8080
sudo ufw allow ssh
sudo ufw --force enable
sudo ufw status

###############################INSTALL KUBECTL CLI###############################
sudo apt update
sudo snap install kubectl --classic

###############################INSTALL TRIVY###############################
sudo apt install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt install trivy -y

