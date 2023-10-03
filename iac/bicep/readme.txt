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
az deployment group create --resource-group $rsgName --template-file main.bicep --parameters clusterName=$clusterName dnsPrefix=$dnsPrefix linuxAdminUsername=$linuxAdminUsername sshRSAPublicKey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqBo5P+U4mUMqFSbglOmlkbds+INstR6SgBudq2IlFY5WmpzvTWVMC4q9fPuahfEjps2og2k0Ritf8wzeg+DlPe/93/Xg7beFp3w2iWLFo40WvThebRLY4XjTeRFJxTUW7hpR+pIyThcvkDWr5fnBMZFTNOYm2WHLdcD+k4WRLxabDPlZ02YnV59Jw6AGgHgtGSaUFSY2E4V+dZQkQcJzLRajo2Wjw5m1FQGt11aL9GUM+GQYR39GyVJBiL2ZllExtGXMexM7KtXtpt4zdTmiRUmoC5bT8IQataGLmwZWl4DQucHwpLFHOzTxhbLhrIvFiVjZbk8G2gStSTAxJjvxwC4zp4VFcee2W32cV9in82NzFzcTML894++KSFVNWnIMCduc5nu6Sv8T9+DimBJ5BI5Mbpo6UkLQSgOJEfd1xxV35UYbgaCidatyiELcN5F1D9+l70EVWBrV06hKpCcQJ1Unc1RaYfBJu4LZ2n9BF1WlEPrtGl09GdT3DL9XJpwU= generated-by-azure'

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
