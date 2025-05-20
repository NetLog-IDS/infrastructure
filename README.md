## How to run the test and get the data:

1. Run `terraform plan -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/system-name.tfvars.json"`. Change system-name to the system you want to test.
2. Run `terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/system-name.tfvars.json"`. Change system-name to the system you want to test.
3. For ml-only and both-new system, set up Apache Flink for the ML. Here's how:
   - Go to http://[ML_IP]:8082. You should see the Apache Flink page.
   - Go to 'Submit New Job' and then clink 'Add new'. Choose the flinkflowmeter-0.4.0.jar files.
   - After the .jar files uploaded successfully, submit new job by clicking on the file name then on the 'Program Arguments' put `--source kafka --source-servers [KAFKA_PRIVATE_IP]:19092 --source-topic network-traffic --source-group flink12 --sink kafka --sink-servers [KAFKA_PRIVATE_IP]:19092 --sink-topic network-flows --mode ordered --sink-topic network-flows --mode ordered`.
   - Go to 'Running Job' page to confirm that the job has been run.
4. Run manual scripts for installing dependecies and downloading test file on Netlog VM.
5. Open IDS dashboard on http://[MONITORING_IP]:8000
6. Run Netlog container.
7. Run ``tcpreplay` command with the files you want to test. Confirm that the IDS dashboard starts to display data.
8. Wait until all the data has been replayed and the system already process the data.
9. Get the data for intrusion detection result on IDS dashboard's MongoDB with connection string `mongodb://mongoadmin:secret@[MONITORING_IP]:27017`. The collected data is on 'network-intrusion-detection' database with 'dos' collection for DoS and 'port_scan' collection for PortScan. You can use MongoDB Compass to connect to the database and download the collections' data as .csv files.
10. Run `terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/system-name.tfvars.json"` to delete the system's infrastructure. Change system-name to the system you want to test. Make sure to destroy then apply again before doing another testing.

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

### Netlog (Bab 4)

- terraform apply -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog.tfvars.json" -auto-approve
- terraform destroy -var-file="./variables/general.tfvars.json" -var-file="./variables/specs/netlog.tfvars.json" -auto-approve
