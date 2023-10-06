#################### PROVISION THE AKS CLUSTER ###############################
// Reference https://www.middlewareinventory.com/blog/terraform-aks-example-creating-azure-k8s-cluster-devops-junction/

// Step 1 (only run this step if the service principal is not created): Setup service principal with syntax: az ad sp create-for-rbac –-name <service_principal_name> –-role Contributor –-scopes /subscriptions/<subscription_id>
az ad sp create-for-rbac --name "sd2411-sp" --role contributor --scopes /subscriptions/e93e5c31-00d6-492c-8751-1626d0a880fe

// Step 2: Init terraform
terraform init

// Step 3: terraform plan
terraform plan --out tfplan.out

// Step 4: terraform apply
terraform apply tfplan.out

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
