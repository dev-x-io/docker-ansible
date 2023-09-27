#!/usr/bin/env python3

# Import necessary modules.
import os
import sys
import subprocess
import json
from pyfiglet import figlet_format

# Fetch the APP_VERSION environment variable. If not set, default to 'v0.0.0'.
container_version = os.environ.get('APP_VERSION', 'v0.0.0')

# This script is the entry point for our Docker container.
# It initializes the environment, checks for requirements, and sets up SSH keys, among other tasks.

# Check for the presence of an Ansible 'requirements.yml' file.
if os.path.isfile("requirements.yml"):
    subprocess.run(["ansible-galaxy", "install", "-r", "requirements.yml", "-p", "/ansible/roles"])

# Check if SSH key files are present in the container.
if not os.path.isfile("/home/ansible/.ssh/id_rsa") or not os.path.isfile("/home/ansible/.ssh/id_rsa.pub"):
    font = figlet_format(f'Testrun {container_version}', font='slant')
    print(font)
    print('SSH keys are absent. Running on localhost powdered milk today!\n')
else:
    subprocess.run(["sudo", "chown", "-R", "ansible:ansible", "/home/ansible/.ssh"])
    subprocess.run(["sudo", "chmod", "600", "/home/ansible/.ssh/*"])
    subprocess.run(["sudo", "chmod", "644", "/home/ansible/.ssh/*.pub"])

# Check for '--deliver-shell' argument.
if '--deliver-shell' in sys.argv:
    with open('commands.json', 'r') as file:
        commands = json.load(file)
    print(json.dumps(commands, indent=4))
    print("Delivering shell")
    subprocess.run(["/bin/bash"])
else:
    # If a command is provided, execute it.
    if len(sys.argv) > 1:
        command = sys.argv[1]
        args = sys.argv[2:]
        try:
            subprocess.run([command] + args)
        except FileNotFoundError as e:
            print(f"An error occurred: {e}")
            print(f"Could not find command: {command}")
    else:
        print("No command provided. Container has ended without applying your secret sauce to success.")
