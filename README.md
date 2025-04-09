Buat multiple instance jalaninnya make (https://spacelift.io/blog/terraform-ec2-instance):
- terraform apply -var-file=specs.tfvars.json -auto-approve
- terraform destroy -var-file="specs.tfvars.json" -auto-approve