#!/bin/sh

# Dit is een opstartscript voor onze container. Wanneer de container start, wordt dit script als eerste uitgevoerd.

# Controleer of er een bestand genaamd "requirements.yml" is.
if [ -f "requirements.yml" ]; then
    # Als dat bestand er is, installeer dan de vereiste Ansible rollen met "ansible-galaxy".
    ansible-galaxy install -r requirements.yml -p /ansible/roles
fi

# Controleer of de SSH-sleutelbestanden aanwezig zijn in de container.
if [ ! -f "/home/ansible/.ssh/id_rsa" ] || [ ! -f "/home/ansible/.ssh/id_rsa.pub" ]; then
    # Als de sleutels ontbreken, toon dan een leuke tekstbanner met de boodschap dat we in een "testmodus" werken.
    python3 -c "import pyfiglet; font = pyfiglet.figlet_format('Testrun v0.0.1', font='slant'); print(font); print('SSH keys are absent. Running on localhost powdered milk today!\n')"
else
    # Als de sleutels aanwezig zijn, zorg er dan voor dat ze de juiste toegangsrechten hebben.
    sudo chown -R ansible:ansible /home/ansible/.ssh  # Geef eigendom aan de "ansible" gebruiker.
    sudo chmod 600 /home/ansible/.ssh/id_rsa          # Zorg ervoor dat het privésleutelbestand alleen leesbaar is door de eigenaar.
    sudo chmod 644 /home/ansible/.ssh/id_rsa.pub      # Zorg ervoor dat het publieke sleutelbestand leesbaar is voor iedereen.
fi

# Voer het commando uit dat aan de container is doorgegeven bij het starten. 
# Bijvoorbeeld: Als we de container starten met "docker run <image> ansible-playbook playbook.yml", 
# dan zou "ansible-playbook playbook.yml" het commando zijn dat hier wordt uitgevoerd.
exec "$@"
