# We beginnen met een lichte versie van het Linux-besturingssysteem genaamd Alpine.
FROM alpine:latest AS base

# Installeer programma's die we nodig hebben: Python, pip (om Python-pakketten te installeren) en Ansible.
RUN apk add --no-cache python3 py3-pip ansible git

# Installeer een Python-pakket genaamd pyfiglet (voor mooie tekst) en Pillow (voor afbeeldingsbewerking).
RUN pip3 install Pillow pyfiglet

# Maak een nieuwe gebruiker genaamd "ansible" zodat niet alles als de hoofdgebruiker wordt uitgevoerd (veiligheidsmaatregel).
# Maak een directory voor Ansible playbooks.
# Maak een directory voor SSH-sleutels.
# Geef eigendom van de directory aan de "ansible" gebruiker.
# Zorg voor de juiste toegangsrechten.
RUN addgroup ansible && \
    adduser -S ansible -G ansible && \
    mkdir /ansible && \
    chown -R ansible:ansible /ansible && \
    mkdir /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible && \
    chmod 700 /home/ansible/.ssh

# Kopieer ons logo naar een standaardlocatie in de container.
COPY img/logo.png /etc/logo.png

# Kopieer ons opstartscript naar de container.
COPY apps/entrypoint.sh /usr/local/bin/

# Stel in welk script er moet worden uitgevoerd wanneer de container start.
ENTRYPOINT ["entrypoint.sh"]

# Hier beginnen we een nieuwe fase van het bouwen van de container.
FROM base AS final

# Installeer extra programma's die we nodig hebben: sudo (om opdrachten als supergebruiker uit te voeren) en openssh (voor SSH-connecties).
RUN apk add --no-cache sudo openssh

# Geef de "ansible" gebruiker toestemming om specifieke commando's uit te voeren zonder een wachtwoord in te voeren.
RUN echo '%ansible ALL=(ALL:ALL) NOPASSWD: /bin/chown, /bin/chmod', '/bin/ping' > /etc/sudoers.d/ansible

# Gebruik de "ansible" gebruiker voor de volgende commando's.
USER ansible

# Stel in welke directory de container moet gebruiken als startpunt.
WORKDIR /ansible

# Als er geen ander commando wordt gegeven bij het starten van de container, toon dan de versie van Ansible.
CMD ["ansible", "--version"]
