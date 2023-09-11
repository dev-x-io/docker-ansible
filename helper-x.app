import os
import subprocess

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

def add_ansible_function_linux():
    bashrc_path = os.path.expanduser("~/.bashrc")
    
    function_name = "ansible"
    if function_exists(function_name):
        function_name = "docker-ansible"
    
    ansible_function = f"""
function {function_name}() {{
    docker run -it --rm -v $(pwd):/ansible devxio/ansible $@
}}
"""

    with open(bashrc_path, 'a+') as f:
        f.seek(0)
        if ansible_function not in f.read():
            f.write(ansible_function)
            print(f"{function_name} functie is toegevoegd aan uw bashrc!")
        else:
            print(f"{function_name} functie is al aanwezig in uw bashrc.")

def add_ansible_function_windows():
    # Verkrijg het pad naar het PowerShell-profiel
    profile_path = subprocess.check_output(['powershell', '-Command', 'echo $PROFILE'], universal_newlines=True).strip()
    
    if not os.path.exists(profile_path):
        with open(profile_path, 'w') as f:
            pass

    function_name = "ansible"
    if function_exists_windows(function_name):
        function_name = "docker-ansible"

    ansible_function = f"""
function {function_name} {{
    docker run -it --rm -v "${{pwd}}:/ansible" devxio/ansible $args
}}
"""

    with open(profile_path, 'a+') as f:
        f.seek(0)
        if ansible_function not in f.read():
            f.write(ansible_function)
            print(f"{function_name} functie is toegevoegd aan uw profiel!")
        else:
            print(f"{function_name} functie is al aanwezig in uw profiel.")

if __name__ == "__main__":
    if os.name == 'posix':
        add_ansible_function_linux()
    elif os.name == 'nt':
        add_ansible_function_windows()
    else:
        print("Onbekend besturingssysteem.")
