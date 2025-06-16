# Infrastructure repository

This repository is for configuring and building the infrastructure for all IDS systems.

## `/terraform` Folder

This folder is the folder to creates the infrastucture on AWS. **Make sure to set up AWS CLI and Terraform before using it!**

File and folder explanation:

- `main.tf` --> Main files for Terraform command
- `flinkflowmeter-X.Y.X.jar` --> .jar files for using Apache Flink wfor system that uses machine learning (`both-new` and `ml-only`). The X, Y, Z is just version identifier.
- `queries.sql` --> .sql files for queris for rule-based KSQL.
- `/variables` --> Contains Terraform variables for all four IDS system.
  - `general.tfvars.json` --> For configuring key pairs for SSH access and file transfer for system that uses KSQL (`both-old` and `netlog-new-only`).
  - `/specs/both-new.tfvars.json` --> Contains the specs for `both-new` IDS system that uses Netlog new (improved Netlog) and machine learning.
  - `/specs/both-old.tfvars.json` --> Contains the specs for `both-old` IDS system that uses Netlog old from previous research and rule-based KSQL.
  - `/specs/ml-only.tfvars.json` --> Contains the specs for `ml-only` IDS system that uses Netlog old and machine learning.
  - `/specs/netlog-new-only.tfvars.json` --> Contains the specs for `netlog-new-only` IDS system that uses Netlog new (improved Netlog) and rule-based KSQL.
- `/scripts` --> Contains scripts for Terraform to run on each component's VM.
- `/manual-scripts` --> Contains scripts that needs to be run manually using SSH on the respected VM. `netlog-new.sh` is for Netlog new and `netlog-old.sh` is for Netlog old.
- `/keys` --> This folder is used to store the private key that can be used to access AWS EC2 VM using SSH. **Make sure to creates the key pair and then put the private key in this folder and the public key on `general.tfvars.json`**

## How to run and test the system

Please look at end-to-end-testing repository on [this link](https://github.com/NetLog-IDS/end-to-end-testing)

## Some Useful Terraform Commands

- terraform apply -var-file=specs.tfvars.json -auto-approve
- terraform destroy -var-file="specs.tfvars.json" -auto-approve

- terraform plan -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json"
- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlogdivies-only.tfvars.json" -auto-approve

- terraform plan -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json"
- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-new.tfvars.json" -auto-approve

- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-old.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-old.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-old.tfvars.json" -auto-approve && terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/both-old.tfvars.json" -auto-approve

Ml

- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/ml-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/ml-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/ml-only.tfvars.json" -auto-approve && terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/ml-only.tfvars.json" -auto-approve

netlog-new

- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog-new-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog-new-only.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog-new-only.tfvars.json" -auto-approve && terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog-new-only.tfvars.json" -auto-approve

### Netlog

Scenarios above are for end-to-end experiment. For experiment on Netlog's performance evaluation, please use the following commands:

- Creating Resources: `terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog.tfvars.json" -auto-approve`
- Destroying Resources: `terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog.tfvars.json" -auto-approve`

## `/docker` Folder

This folder is the folder to create infrastructure on local. It is used for debugging, generation, or evaluation where the results are not dependent to the infrastructure specs (e.g. feature calculation and prediction).

- `docker-compose-ksql.yml`: For prediction using ksqlDB.
- `docker-compose-flink.yml`: For dataset feature recalculation. You can ignore starting `portscan`, `dos`, `mongodb`, and `monitoring` for recalculation purpose.
- `kafka-specs`: Declaring Kafka topics.

### Commands

Do not forget to change PCAP location on the `.yml` configuration. After that, use the commands below to run the infrastructure locally.

- ML Dataset Recalculation: Use `docker-compose-flink-recalculation.yml` for recalculating the features of CICIDS2017 flows. For converting to CSV and merging labels, please see [Analyzer Repository](https://github.com/NetLog-IDS/intrusion-detection).

  ```bash
  docker compose -f docker-compose-flink-recalculation.yml up -d
  ```

- ML Local Debugging: Use `docker-compose-flink-local.yml` for debugging end-to-end ML testing in local. For the real e2e test, please use Terraform configuration instead (`../terraform`). The difference from `ML Dataset Recalculation` scenario is that this configuration also includes ML consumer, monitoring service, and mongodb.

  ```bash
  docker compose -f docker-compose-flink-local.yml up -d
  ```

- ksqlDB Local Debugging: Use `docker-compose-flink-ksql.yml` for debugging end-to-end ksqlDB testing in local. For the real e2e test, please use Terraform configuration instead (`../terraform`).
  ```bash
  docker compose -f docker-compose-ksql.yml up -d
  ```
