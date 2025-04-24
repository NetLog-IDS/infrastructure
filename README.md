Pastiin scriptnya make lf bukan crlf klo dia not found bilangnya.

Buat multiple instance jalaninnya make (https://spacelift.io/blog/terraform-ec2-instance):

- terraform apply -var-file=specs.tfvars.json -auto-approve
- terraform destroy -var-file="specs.tfvars.json" -auto-approve

- terraform plan -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json"
- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json" -auto-approve

- terraform plan -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json"
- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json" -auto-approve
