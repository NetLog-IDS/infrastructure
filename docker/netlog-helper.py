import os
import subprocess

# you can use editpcap -c <number of packets each split> <input-file> <output-file-prefix> to split big PCAP

input_folder = "/home/meervix/pcaptest" # folder for splitted PCAP files
file_prefix = "testsplit_" # splitted PCAP file prefixes.. note that the earlier pcap must be lower lexicographically
compose_config = "docker-compose-flink-recalculation.yml" # run all the other services, except netlog

files = [ os.path.join(input_folder, f) for f in os.listdir(input_folder) if f.startswith(file_prefix)]
files.sort()

print(files)

def run_netlog_on_split(file_path: str):
    env = {
        "INPUT_PCAP_PATH": file_path
    }

    command = [
        "docker", "compose",
        "-f", compose_config,
        "up", "netlog",
    ]

    subprocess.run(command, env={**env, **dict(**os.environ)}, check=True)

[ run_netlog_on_split(f) for f in files ]
