import os
import subprocess

ANSIBLE_COMMANDS = [
    ("ansible", "🤖"),
    ("ansible-config", "⚙️"),
    ("ansible-console", "🎮"),
    ("ansible-galaxy", "🌌"),
    ("ansible-playbook", "📘"),
    ("ansible-test", "🧪"),
    ("ansible-community", "🌍"),
    ("ansible-connection", "🔗"),
    ("ansible-doc", "📄"),
    ("ansible-inventory", "📦"),
    ("ansible-pull", "⬇️"),
    ("ansible-vault", "🔐")
]

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

    for cmd, emoji in ANSIBLE_COMMANDS:
        function_name = cmd
        if function_exists(function_name):
            function_name = "docker-" + cmd
        
        ansible_function = f"""
function {function_name}() {{
    docker run -it --rm -v $(pwd):/ansible devxio/ansible {cmd} $@
}}
"""

        with open(bashrc_path, 'a+') as f:
            f.seek(0)
            if ansible_function not in f.read():
                f.write(ansible_function)
                added_aliases.append((emoji, function_name))

    display_report(added_aliases)

def add_ansible_aliases_windows():
    profile_path = subprocess.check_output(['powershell', '-Command', 'echo $PROFILE'], universal_newlines=True).strip()
    
    if not os.path.exists(profile_path):
        with open(profile_path, 'w') as f:
            pass

    added_aliases = []

    for cmd, emoji in ANSIBLE_COMMANDS:
        function_name = cmd
        if function_exists_windows(function_name):
            function_name = "docker-" + cmd

        ansible_function = f"""
function {function_name}() {{
    docker run -it --rm -v "${{pwd}}:/ansible" devxio/ansible {cmd} $args
}}
"""

        with open(profile_path, 'a+') as f:
            f.seek(0)
            if ansible_function not in f.read():
                f.write(ansible_function)
                added_aliases.append((emoji, function_name))

    display_report(added_aliases)

def display_report(added_aliases):
    print("Rapport van toegevoegde functies:")
    for emoji, cmd in added_aliases:
        print(f"{emoji} {cmd}")

if __name__ == "__main__":
    if os.name == 'posix':
        add_ansible_aliases_linux()
    elif os.name == 'nt':
        add_ansible_aliases_windows()
    else:
        print("Onbekend besturingssysteem.")
