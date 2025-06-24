# `/docker` Folder

This folder is the folder to create infrastructure on local. It is used for debugging, generation, or evaluation where the results are not dependent to the infrastructure specs (e.g. feature calculation and prediction).

## Commands

Use the commands below to run the infrastructure locally.

- ML Dataset Recalculation: Use `docker-compose-flink-recalculation.yml` for recalculating the features of CICIDS2017 flows. For converting to CSV and merging labels, please see [Analyzer Repository](https://github.com/NetLog-IDS/intrusion-detection).

  ```bash
  INPUT_PCAP_PATH=<pcap-location> docker compose -f docker-compose-flink-recalculation.yml up -d
  ```

- ML Local Debugging: Use `docker-compose-flink-local.yml` for debugging end-to-end ML testing in local. For the real e2e test, please use Terraform configuration instead (`../terraform`). The difference from `ML Dataset Recalculation` scenario is that this configuration also includes ML consumer, monitoring service, and mongodb.

  ```bash
  INPUT_PCAP_PATH=<pcap-location> docker compose -f docker-compose-flink-local.yml up -d
  ```

- ksqlDB Local Debugging: Use `docker-compose-flink-ksql.yml` for ksqlDB prediction evaluation or debugging ksqlDB end-to-end in local. For the real e2e test, please use Terraform configuration instead (`../terraform`).
  ```bash
  INPUT_PCAP_PATH=<pcap-location> docker compose -f docker-compose-ksql.yml up -d
  ```

If input PCAP are too big, split PCAP using `editpcap -c <number of packets each split> <input-file> <output-file-prefix>`, and use `netlog-helper.py` for sending splitted PCAPs sequentially.
