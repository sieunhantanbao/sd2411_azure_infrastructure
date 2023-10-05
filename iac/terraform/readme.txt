// Reference https://www.middlewareinventory.com/blog/terraform-aks-example-creating-azure-k8s-cluster-devops-junction/

// Step 0: run below commands to set variables
region='southcentralus'
rsgName='sd2411'
clusterName='sd2411_k8s_cluster'
dnsPrefix='sd2411-my-todo-dns'
linuxAdminUsername='sd2411user'

// Step 1: Setup service principal with syntax: az ad sp create-for-rbac –-name <service_principal_name> –-role Contributor –-scopes /subscriptions/<subscription_id>
az ad sp create-for-rbac --name "sd2411-sp" --role contributor --scopes /subscriptions/e93e5c31-00d6-492c-8751-1626d0a880fe

// output
{
  "appId": "6f741a6b-a89f-4b71-a1cc-d19e2a0c31ea",
  "displayName": "sd2411-sp",
  "password": "GUM8Q~05PR451568Skk8nT.AaKMXAuBsBtUDCcLj",
  "tenant": "b06d42c5-106b-4dfc-b483-8520b3a15e50"
}


// Step 2: Create a resource group
az group create -l $region -n $rsgName

// Step 3: Create SSH (using Azure Cloud Shell). Then save the Pubic Key value for later use
az sshkey create --name "mySSHKey" --resource-group $rsgName