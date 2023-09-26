// Variables
rsgName='sd2411'
clusterName='sd2411_k8s_cluster'
dnsPrefix='sd2411-my-todo-dns'
linuxAdminUsername='sd2411user'

// Step 1: Create resource group
az group create -l southeastasia -n $rsgName


// Setp 2: Create SSH (using Azure Cloud Shell)
az sshkey create --name "mySSHKey" --resource-group $rsgName
#ssh-keygen -t rsa -b 4096

// Copy the output something like below
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCiwEqrLaIaXUxedbkxHP5FPTeReZQoak5yTC2COQUZcqaeU0OPjjmekpAKkO/yRbr1g+6+JI+YCeeUghM/vQsvZ8gVS/gNJLPgW463fq93xfjkm0DNG/MnEGGSazq9WNn48329daQJPtaWtlVHI9keYfntjZp3LDesp7f2ekL4uC/kH6Du9IQZiB1F3E4HOBMInFPuA7fr6KTZHWx1PA2bKKwtcFXvrOG8vZ4z0ePeGgLwwUwyTy1a+9aWI5u0y/JJ6CdArEQbijRZbLrZcb9uku7i+YRmwMaVRo8/pGHvdXTjqh9wBXYRjlNsNgtr5BselmxsQhtq99M96bi1/x1S0LRJm9hl+G85CzfvygwmzSDUE7dAjcTBthcMG4xMUDD7MpJvDF8RBLerFWUe3VQCZufwkrNKvBbbkcWVprgPYPC+n9xvzMHkdzHy2M+MJ2ZzvtY5H06UVnyW2QOXTut2m7nG5vDIQ//n1PVT/BugoZraZr0UUzDA6dKCwJUJ8F0= generated-by-azure

// Step 3: Create AKS cluster (pass the above value to the <ssh-key> below)
az deployment group create --resource-group $rsgName --template-file main.bicep --parameters clusterName=$clusterName dnsPrefix=$dnsPrefix linuxAdminUsername=$linuxAdminUsername sshRSAPublicKey='<ssh-key>'

// Step 4: Get 
az aks get-credentials --resource-group $rsgName --name $clusterName

Reference: https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-bicep?tabs=azure-cli