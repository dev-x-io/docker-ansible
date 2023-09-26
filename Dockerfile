# Pin to a specific version of Alpine for reproducibility.
FROM alpine:3.18.3 AS base

# Install essential programs in a single RUN statement to minimize layers.
RUN apk add --no-cache python3 py3-pip ansible git nmap

# Install Python packages.
RUN pip3 install jinja2 Pillow pyfiglet

# Create a new non-root user and set up directories.
RUN addgroup ansible && \
    adduser -S ansible -G ansible && \
    mkdir /ansible && \
    chown -R ansible /ansible && \
    mkdir -p /home/ansible/.ssh && \
    chown -R ansible:ansible /home/ansible && \
    chmod 700 /home/ansible/.ssh

# Copy files into the container.
COPY img/logo.png /etc/logo.png
COPY apps/entrypoint.py /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.py  # Make the script executable

# Set entrypoint script.
ENTRYPOINT ["python3", "/usr/local/bin/entrypoint.py"]

# Switch to a new build stage.
FROM base AS final

# Declare APP_VERSION for the base stage
ARG APP_VERSION=v0.0.0
ENV APP_VERSION=${APP_VERSION}

# Install additional packages.
RUN apk add --no-cache sudo openssh

# Allow the "ansible" user to run specific commands without entering a password.
RUN echo '%ansible ALL=(ALL:ALL) NOPASSWD: /bin/chown, /bin/chmod, /bin/ping', '/bin/nmap' > /etc/sudoers.d/ansible

# Switch to non-root user and set the working directory.
USER ansible
WORKDIR /ansible
