#################### PROVISIONNING AKS CLUSTER ###############################
// Variables
region='southcentralus'
rsgName='sd2411'
clusterName='sd2411_k8s_cluster'
dnsPrefix='sd2411-my-todo-dns'
linuxAdminUsername='sd2411user'

// Step 1: Create resource group
az group create -l $region -n $rsgName


// Setp 2: Create SSH (using Azure Cloud Shell)
az sshkey create --name "mySSHKey" --resource-group $rsgName
#ssh-keygen -t rsa -b 4096

// Copy the output something like below
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiwEqrLaIaXUxedbkxHP5FPTeReZQoak5yTC2COQUZcqaeU0OPjjmekpAKkO/yRbr1g+6+JI+YCeeUghM/vQsvZ8gVS/gNJLPgW463fq93xfjkm0DNG/MnEGGSazq9WNn48329daQJPtaWtlVHI9keYfntjZp3LDesp7f2ekL4uC/kH6Du9IQZiB1F3E4HOBMInFPuA7fr6KTZHWx1PA2bKKwtcFXvrOG8vZ4z0ePeGgLwwUwyTy1a+9aWI5u0y/JJ6CdArEQbijRZbLrZcb9uku7i+YRmwMaVRo8/pGHvdXTjqh9wBXYRjlNsNgtr5BselmxsQhtq99M96bi1/x1S0LRJm9hl+G85CzfvygwmzSDUE7dAjcTBthcMG4xMUDD7MpJvDF8RBLerFWUe3VQCZufwkrNKvBbbkcWVprgPYPC+n9xvzMHkdzHy2M+MJ2ZzvtY5H06UVnyW2QOXTut2m7nG5vDIQ//n1PVT/BugoZraZr0UUzDA6dKCwJUJ8F0= generated-by-azure

// Step 3: Create AKS cluster (pass the above value to the <ssh-key> below)
az deployment group create --resource-group $rsgName --template-file main.bicep --parameters clusterName=$clusterName dnsPrefix=$dnsPrefix linuxAdminUsername=$linuxAdminUsername sshRSAPublicKey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx+doGHJBB0G7AtizztBY5AnkIfXNtDHpLcxBaTfIf0b65HB+BRfF+/62PyaeOzg+IsjVBzusa0zts2gwwvxgRa6ymzYmDKVZ9NGwX8zEmOVxjwBJ712eI+D6veDRzSicOl+ZeGFHcb+RksVhWV0p42dxAPY42kzlQ0rj4vqzqFVQJzdEJyi8QEBqcz/X/F9o3z5bph7+jbBmbFHBZL+XJv8sUMIaM4dl7BM4zIeqDZ0ZM0YD/e2aLU3TUlG1JE9MF1NN5C/MlFdai2/8AcuzDlDQZMUhrpBcA1yRXv9H4sSqEzayd7EdtNMeFrSCJqdnYyexgIUegfNPOpVDh+SO34DuQN5SxlHnYkGzHkcQ0H8AUXaSzH+bLMiHAupfM5IEPOjjIDIboHVUvuo5tIELD/938sYXxBs6jYs60qDUC7znM4DnZ0499EpDcwY/UiVxJDSy1pX9odUkSZk9TKUTSymOLaB5wMI86/Kov8LBcyZuCYVEHrRPV2rmrtDpGtxk= generated-by-azure'

// Step 4: Get 
az aks get-credentials --resource-group $rsgName --name $clusterName

Reference: https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep?tabs=azure-cli


#################### INSTALLING ARGO CD ###############################
Reference: https://harveynashvn-my.sharepoint.com/:w:/g/personal/lecao_nashtechglobal_com/EZRdk4wom9dOs1Svl-YuoTwBqy9njh_kVHpiTIUUQgAP_g?wdOrigin=TEAMS-WEB.p2p_ns.bim&wdExp=TEAMS-CONTROL&wdhostclicktime=1695797738297&web=1
// Step 1: Create namespace
kubectl create namespace argocd

// Step 2: Install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

// Step 3: Edit argocd-server to change (ClusterIP to LoadBalancer)
kubectl edit svc argocd-server -n argocd

// Step 4: Get ArgoCD password (username: admin)
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d

// Step 5: Login to ArgoCD by the External IP (URL) from the argocd-server service
