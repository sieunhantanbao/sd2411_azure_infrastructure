// Step 1: Provisioning the VM - this includes the docker, jenkins installation
terraform init
terraform plan -out tfplan.out
terraform apply tfplan.out

// Step 2: Setup Jenkins: https://www.cherryservers.com/blog/how-to-install-jenkins-on-ubuntu-22-04
// 2.1 Goto http://<VM_public_Ip>:8080
// 2.2 Retrieve the initial password by command below (after SSH to the VM) and put to the site in 2.1
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

