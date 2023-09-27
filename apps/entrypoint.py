#!/usr/bin/env python3

import os
import sys
import subprocess
import json

# Fetch the APP_VERSION environment variable. If not set, default to 'v0.0.0'.
container_version = os.environ.get('APP_VERSION', 'v0.0.0')

# Check for Ansible requirements.yml
if os.path.isfile("requirements.yml"):
    subprocess.run(["ansible-galaxy", "install", "-r", "requirements.yml", "-p", "/ansible/roles"])

# Check for SSH keys
if not os.path.isfile("/home/ansible/.ssh/id_rsa") or not os.path.isfile("/home/ansible/.ssh/id_rsa.pub"):
    print(f'Testrun {container_version}')
    print('SSH keys are absent. Running on localhost powdered milk today!\n')
else:
    subprocess.run(["sudo", "chown", "-R", "ansible:ansible", "/home/ansible/.ssh"])
    subprocess.run(["sudo", "chmod", "600", "/home/ansible/.ssh/*"])
    subprocess.run(["sudo", "chmod", "644", "/home/ansible/.ssh/*.pub"])

# Check for --deliver-shell argument
if '--deliver-shell' in sys.argv:
    with open('commands.json', 'r') as file:
        commands = json.load(file)
    print(json.dumps(commands, indent=4))
    print("Delivering shell")
    subprocess.run(["/bin/bash"])
else:
    # Process the command and arguments
    if len(sys.argv) > 1:
        full_command = sys.argv[1:]
        try:
            subprocess.run(full_command)
        except FileNotFoundError as e:
            print(f"An error occurred: {e}")
            print(f"Could not find command: {full_command[0]}")
    else:
        print("No command provided. Container has ended without applying your secret sauce to success.")
