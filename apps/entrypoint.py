#!/usr/bin/env python3
import os
import sys
import subprocess
import json
from pyfiglet import figlet_format

# Fetch the APP_VERSION environment variable or use a default of 'v0.0.0' if not set.
container_version = os.environ['APP_VERSION']

# This is a startup script for our container. When the container starts, this script is executed first.

# Check if a file named "requirements.yml" exists.
if os.path.isfile("requirements.yml"):
    # If that file exists, install the required Ansible roles with "ansible-galaxy".
    subprocess.run(["ansible-galaxy", "install", "-r", "requirements.yml", "-p", "/ansible/roles"])

# Check if the SSH key files are present in the container.
if not os.path.isfile("/home/ansible/.ssh/id_rsa") or not os.path.isfile("/home/ansible/.ssh/id_rsa.pub"):
    # If the keys are missing, display a cool text banner indicating we are in "test mode".
    font = figlet_format(f'Testrun {container_version}', font='slant')
    print(font)
    print('SSH keys are absent. Running on localhost powdered milk today!\n')
else:
    # If the keys are present, ensure they have the correct access rights.
    subprocess.run(["sudo", "chown", "-R", "ansible:ansible", "/home/ansible/.ssh"])  # Grant ownership to the "ansible" user.
    subprocess.run(["sudo", "chmod", "600", "/home/ansible/.ssh/id_rsa"])  # Ensure the private key file is only readable by the owner.
    subprocess.run(["sudo", "chmod", "644", "/home/ansible/.ssh/id_rsa.pub"])  # Ensure the public key file is readable by everyone.

if '--deliver-shell' in sys.argv:
    # Load the JSON structure from commands.json
    with open('commands.json', 'r') as file:
        commands = json.load(file)
    print(json.dumps(commands, indent=4))
    print("Delivering shell")
    subprocess.run(["/bin/bash"])
else:
    # Execute the command passed to the container during startup.
    if len(sys.argv) > 1:
        subprocess.run(sys.argv[1:])
    else:
        print("No command provided. Container has ended without applying your secret sauce to success.")