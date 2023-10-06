// Step 1: Init terraform
terraform init

// Step 2: terraform plan
terraform plan --out tfplan.out

// Step 3: terraform apply
terraform apply tfplan.out