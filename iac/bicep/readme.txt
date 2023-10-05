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
az deployment group create --resource-group $rsgName --template-file main.bicep --parameters clusterName=$clusterName dnsPrefix=$dnsPrefix linuxAdminUsername=$linuxAdminUsername sshRSAPublicKey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDs1+NBrsXSlxgibrmZ5mrDoqm6hq5E6Dh8p///GyflvIOBPB0k98bPow0cSCJYbRU3kmp3W4FEPU0xoVWbYQ+3QTv7EihIiVYl8Nv7mI8P4yPxZFbTBAqV5tsTR7DnmrqAIZMZuKkP+WTSabF0U8gDT/MB3rQzF9oiQouFQO4Meyca5UfYiJzJstk0HLScqGzZAOw/en9lkHsEPqZz3dteNRkuitAKW/sCM0mhzMjB8cDIBUYPjZAn7kdtqFagN5veXfTnFogx7k74H6b38HQnok/p02B04LYzlbRkc2lEDm9jThA+sQCKw4LvDUSSFoOtuZvz9FuinCztEiEIY+8xy5iJNBAOVFaJFwcR7PTBtmGUMo9VDztRR/sF7jCxHNM8BDMYrIzHqgWRmEcC8ktmpUoENSpLxnP0mcP7bhjPxANoWRqsz+9pEmcDIrnY/R7XrITorzWYMaysHd6e6VyY10G0W/DBMHXiqfhG11SEAjYo9/eznVi8sV0wfhC/Khk= generated-by-azure'

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


###################### UPLOAD ARGOCD MANIFESTS (YML FILES)#######################################
// CD to 'argocd/environment-promotion' and run these commands
kubectl create namespace qa
kubectl create namespace staging
kubectl create namespace prod

kubectl apply -f qa.yml -n argocd
kubectl apply -f staging.yml -n argocd
kubectl apply -f prod.yml -n argocd
