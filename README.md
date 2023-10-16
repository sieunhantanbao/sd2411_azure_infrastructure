# SD2411 Infrastructure
## Prerequisite Tools
- [Azure Command-line Interface (CLI)](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
## Infrastructure set up
### Provision Azure Kunerbetes Service (AKS)
- Change directory (cd) to iac/terraform/aks: `cd iac/terraform/aks`
- Update the variables in the `variables.tf` file to suistatble with you want
- Run the below commands
	- `terraform init`
	- `terraform plan --out tfplan.out`
	- `terraform apply tfplan.out`
### Provision Azure Container Registry (ACR)
- Change directory (cd) to iac/terraform/aks/acr: `cd iac/terraform/acr`
- Update the variables in the `variables.tf` file to suistable with you want
- Run below command
	- `terraform init`
	- `terraform plan --out tfplan.out`
	- `terraform apply tfplan.out`
### Provision Virtual Machine (VMs)
This will provision an Ubuntu VM with **Docker** and **Jenkins** installed
- Change directory (cd) to iac/terraform/aks/vm: `cd iac/terraform/vm`
- Update the variables in the `variables.tf` file to suistable with you want
- Run below command
	- `terraform init`
	- `terraform plan --out tfplan.out`
	- `terraform apply tfplan.out`

<u>Note:</u> The script to install **Docker** and **Jenkins** can be found in `azure-user-data.sh`
### Install ArgoCD (with helm support enable)
- Get AKS credential: `az aks get-credentials --resource-group <your_resource_group_name> --name <your_aks_cluster_name>`
- Create argocd namespace: `kubectl create namespace argocd`
- From the root of the project, run this command `kubectl apply -n argocd -f install-argocd.yaml`
- Edit argocd-server to change (ClusterIP to LoadBalancer): `kubectl edit svc argocd-server -n argocd`
- Get ArgoCD password (username: admin): `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d`
- Login to ArgoCD by the External IP (URL) from the argocd-server service: `kubectl get svc argocd-server -n argocd`
### Setup Jenkins on Virtual Machine
The step **Provision Virtual Machine** has already installed a Jenkins. Please refer to [How To Install Jenkins on Ubuntu 22.04](https://www.cherryservers.com/blog/how-to-install-jenkins-on-ubuntu-22-04) **(starts from step #6: Set up Jenkins)**
While setup the Jenkins, please make sure the plugins below get installed
- Jenkins suggested plugins
-  Docker PipelineVersion
- Pipeline Utility Steps
## Deploy application with ArgoCD
### Prerequisite setup
- Application's source code: https://github.com/sieunhantanbao/sd2411_msa
- The CI project: https://github.com/sieunhantanbao/sd2411-devops-ci
- Github Helm chart repository [SD2411 Helm chart](https://sieunhantanbao.github.io/sd2411-helm-charts/) to store the helm packages to be used by the argocd (with helm deployment) below.

### Deploy application
- Change directory (cd) to argocd/helm/{environment_name} (i.e. `cd argocd/helm/qa`) and run the below commands
	- Deploy the Azure Container Registry (ACR) secret. Please refer here to create a new Service Principal for the ACR: [Pull images from an Azure container registry to a Kubernetes cluster using a pull secret](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes). This will allow the helm to pull the images from the ACR.
		- `kubectl create ns qa`
		- `kubectl  create  secret  docker-registry  qa-acr-secret  \ --namespace  qa  \
--docker-server=<conatiner registry name>.azurecr.io  \
--docker-username=<Service principal ID>  \
--docker-password=<Service principal password>`
	- Deploy database: `kubectl apply -f 1-postgres.yml`
	- Deploy backend: `kubectl apply -f 2-backend.yml`
	- Deploy frontend: `kubectl apply -f 3-frontend.yml`

## Manage the application on the ArgoCD UI
### TBD