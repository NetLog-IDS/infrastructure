Buat multiple instance jalaninnya make (https://spacelift.io/blog/terraform-ec2-instance):
- terraform plan -var-file=specs.tfvar 
- terraform apply -var-file=specs.tfvar -auto-approve
- terraform destroy -var-file=specs.tfvar -auto-approve