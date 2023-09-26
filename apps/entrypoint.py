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
    # If the file exists, install the roles listed in it using 'ansible-galaxy'.
    subprocess.run(["ansible-galaxy", "install", "-r", "requirements.yml", "-p", "/ansible/roles"])

# Check if SSH key files are present in the container.
if not os.path.isfile("/home/ansible/.ssh/id_rsa") or not os.path.isfile("/home/ansible/.ssh/id_rsa.pub"):
    # No SSH keys found. We're in "test mode".
    font = figlet_format(f'Testrun {container_version}', font='slant')
    print(font)
    print('SSH keys are absent. Running on localhost powdered milk today!\n')
else:
    # SSH keys found. Set the correct ownership and permissions.
    subprocess.run(["sudo", "chown", "-R", "ansible:ansible", "/home/ansible/.ssh"])  # Change ownership to 'ansible' user.
    subprocess.run(["sudo", "chmod", "600", "/home/ansible/.ssh/*"])  # Set private keys to be read-only by the owner.
    subprocess.run(["sudo", "chmod", "644", "/home/ansible/.ssh/*.pub"])  # Set public keys to be readable by everyone.

# Check for a '--deliver-shell' argument when starting the container.
if '--deliver-shell' in sys.argv:
    # Load and pretty-print the JSON structure from 'commands.json'.
    with open('commands.json', 'r') as file:
        commands = json.load(file)
    print(json.dumps(commands, indent=4))
    print("Delivering shell")
    subprocess.run(["/bin/bash"])  # Start a shell session.
else:
    # If a command is provided, execute it. Otherwise, print a message and exit.
    if len(sys.argv) > 1:
        subprocess.run(sys.argv[1:])
    else:
        print("No command provided. Container has ended without applying your secret sauce to success.")
