// Reference https://www.middlewareinventory.com/blog/terraform-aks-example-creating-azure-k8s-cluster-devops-junction/

// Step 1 (only run this step if the service principal is not created): Setup service principal with syntax: az ad sp create-for-rbac –-name <service_principal_name> –-role Contributor –-scopes /subscriptions/<subscription_id>
az ad sp create-for-rbac --name "sd2411-sp" --role contributor --scopes /subscriptions/e93e5c31-00d6-492c-8751-1626d0a880fe

// Step 2: Init terraform
terraform init

// Step 3: terraform plan
terraform plan --out tfplan.out

// Step 4: terraform apply
terraform apply tfplan.out