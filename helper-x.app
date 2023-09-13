import os
import subprocess

DOCKER_IMAGE = "devxio/ansible"
ANSIBLE_COMMANDS = [
    "ansible",
    "ansible-config",
    "ansible-console",
    "ansible-galaxy",
    "ansible-playbook",
    "ansible-test",
    "ansible-community",
    "ansible-connection",
    "ansible-doc",
    "ansible-inventory",
    "ansible-pull",
    "ansible-vault"
]

SSH_DIR_PATH = os.environ.get('ANSIBLE_SSH_DIR_PATH', os.path.expanduser('~/.ssh'))

def config_ssh_dir_path():
    new_path = input("Voer het nieuwe pad in voor ANSIBLE_SSH_DIR_PATH: ").strip()
    with open(os.path.expanduser("~/.bashrc"), 'a') as f:
        f.write(f"\nexport ANSIBLE_SSH_DIR_PATH={new_path}\n")
    print(f"ANSIBLE_SSH_DIR_PATH is geconfigureerd naar {new_path}")

def function_exists(function_name):
    """Controleer of een gegeven functie bestaat in de shell (voor Linux)."""
    return os.system(f"type {function_name} > /dev/null 2>&1") == 0

def function_exists_windows(function_name):
    """Controleer of een gegeven functie bestaat in PowerShell."""
    try:
        output = subprocess.check_output(['powershell', '-Command', f'Get-Command {function_name}'], universal_newlines=True).strip()
        return bool(output)
    except subprocess.CalledProcessError:
        return False

def add_ansible_aliases_linux():
    bashrc_path = os.path.expanduser("~/.bashrc")
    
    added_aliases = []

    for cmd in ANSIBLE_COMMANDS:
        function_name = cmd
        if function_exists(function_name):
            function_name = "docker-" + cmd
        
        ansible_function = f"""
function {function_name}() {{
    docker run -it --rm -v $(pwd):/ansible -v {SSH_DIR_PATH}:{SSH_DIR_PATH} {DOCKER_IMAGE} {cmd} $@
}}
"""

        with open(bashrc_path, 'a+') as f:
            f.seek(0)
            if ansible_function not in f.read():
                f.write(ansible_function)
                added_aliases.append(function_name)

    display_report(added_aliases)

def add_ansible_aliases_windows():
    profile_path = subprocess.check_output(['powershell', '-Command', 'echo $PROFILE'], universal_newlines=True).strip()
    
    if not os.path.exists(profile_path):
        with open(profile_path, 'w') as f:
            pass

    added_aliases = []

    for cmd in ANSIBLE_COMMANDS:
        function_name = cmd
        if function_exists_windows(function_name):
            function_name = "docker-" + cmd

        ansible_function = f"""
function {function_name}() {{
    docker run -it --rm -v "${{pwd}}:/ansible" -v "{SSH_DIR_PATH}:{SSH_DIR_PATH}" {DOCKER_IMAGE} {cmd} $args
}}
"""

        with open(profile_path, 'a+') as f:
            f.seek(0)
            if ansible_function not in f.read():
                f.write(ansible_function)
                added_aliases.append(function_name)

    display_report(added_aliases)

def display_report(added_aliases):
    print("\nRapport van toegevoegde functies:")
    print("-" * 40)
    print(f"Bron Docker Image: {DOCKER_IMAGE}\n")
    for cmd in added_aliases:
        print(f"  - {cmd}")
    print("-" * 40)

if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == 'config-ssh-ansible':
        config_ssh_dir_path()
    elif os.name == 'posix':
        add_ansible_aliases_linux()
    elif os.name == 'nt':
        add_ansible_aliases_windows()
    else:
        print("Onbekend besturingssysteem.")
