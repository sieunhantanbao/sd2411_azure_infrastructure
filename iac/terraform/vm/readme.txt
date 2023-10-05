// Step 1: Provisioning the VM
terraform init
terraform plan -out tfplan.out
terraform apply tfplan.out

// Step 2: Install docker
// Access (SSH) to the VM and run below commands
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
sudo usermod -aG docker $USER


// Step 3: Install Jenkins: https://www.cherryservers.com/blog/how-to-install-jenkins-on-ubuntu-22-04

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
