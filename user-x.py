import os
import subprocess

def add_ansible_function_linux():
    bashrc_path = os.path.expanduser("~/.bashrc")
    
    ansible_function = """
function ansible() {
    docker run -it --rm -v $(pwd):/ansible devxio/ansible
}
"""

    with open(bashrc_path, 'a+') as f:
        f.seek(0)
        if ansible_function not in f.read():
            f.write(ansible_function)
            print("Ansible functie is toegevoegd aan uw bashrc!")
        else:
            print("Ansible functie is al aanwezig in uw bashrc.")

def add_ansible_function_windows():
    # Verkrijg het pad naar het PowerShell-profiel
    profile_path = subprocess.check_output(['powershell', '-Command', 'echo $PROFILE'], universal_newlines=True).strip()
    
    if not os.path.exists(profile_path):
        with open(profile_path, 'w') as f:
            pass

    ansible_function = """
function ansible {
    docker run -it --rm -v "${pwd}:/ansible" devxio/ansible
}
"""

    with open(profile_path, 'a+') as f:
        f.seek(0)
        if ansible_function not in f.read():
            f.write(ansible_function)
            print("Ansible functie is toegevoegd aan uw profiel!")
        else:
            print("Ansible functie is al aanwezig in uw profiel.")

if __name__ == "__main__":
    if os.name == 'posix':
        add_ansible_function_linux()
    elif os.name == 'nt':
        add_ansible_function_windows()
    else:
        print("Onbekend besturingssysteem.")
