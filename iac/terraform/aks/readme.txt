#################### PROVISION THE AKS CLUSTER ###############################
// Reference https://www.middlewareinventory.com/blog/terraform-aks-example-creating-azure-k8s-cluster-devops-junction/

// Step 1: Init terraform
terraform init

// Step 2: terraform plan
terraform plan --out tfplan.out

// Step 3: terraform apply
terraform apply tfplan.out

az aks get-credentials --resource-group rg_sd2411_aks --name sd2411_k8s_cluster
#################### INSTALLING ARGO CD ###############################
Reference: https://harveynashvn-my.sharepoint.com/:w:/g/personal/lecao_nashtechglobal_com/EZRdk4wom9dOs1Svl-YuoTwBqy9njh_kVHpiTIUUQgAP_g?wdOrigin=TEAMS-WEB.p2p_ns.bim&wdExp=TEAMS-CONTROL&wdhostclicktime=1695797738297&web=1
// Step 1: Create namespace
kubectl create namespace argocd

// Step 2: Install argocd
// kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
// Go to the root of repository and run command
kubectl apply -n argocd -f install-argocd.yaml

// Step 3: Edit argocd-server to change (ClusterIP to LoadBalancer)
kubectl edit svc argocd-server -n argocd

// Step 4: Get ArgoCD password (username: admin)
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d

// Step 5: Login to ArgoCD by the External IP (URL) from the argocd-server service
kubectl get svc argocd-server -n argocd