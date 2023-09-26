# Start with a lightweight base image (Alpine Linux).
# We're using a multi-stage build process. This is the "build" stage.
FROM alpine:3.18.3 AS build

# Copy the Python script that will be the entry point of our application.
# This makes it available for further stages.
COPY apps/entrypoint.py /usr/local/bin/

# Install essential packages and Python libraries, then clean up to reduce image size.
# 1. py3-pip is a package manager for Python packages.
# 2. python3 and ansible are the main packages we need.
# 3. pyfiglet is a Python library for fancy text rendering.
# 4. Cleanup steps remove unnecessary cache and temp files.
RUN apk add --no-cache --virtual .build-deps py3-pip && \
    apk add --no-cache python3 ansible && \
    pip3 install --no-cache-dir pyfiglet && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* /root/.cache && \
    chmod +x /usr/local/bin/entrypoint.py  # Make the script executable

# This is the final stage, where we gather only the artifacts we need.
FROM alpine:3.18.3 AS final

# Declare and set a version environment variable.
# This can be overridden at build-time using: docker build --build-arg APP_VERSION=new_value
ARG APP_VERSION=v0.0.0
ENV APP_VERSION=${APP_VERSION}

# Copy essential files from the previous stage.
# This includes our entry point script and Python libraries.
COPY --from=build /usr/local/bin/entrypoint.py /usr/local/bin/entrypoint.py
COPY --from=build /usr/lib/python3.11/site-packages/ /usr/lib/python3.11/site-packages/

# Install only the necessary packages to run our application.
# nmap and openssh are for network scanning and SSH connectivity.
# sudo is for privilege escalation.
RUN apk add --no-cache python3 nmap openssh sudo && \
    echo '%ansible ALL=(ALL:ALL) NOPASSWD: /bin/chown, /bin/chmod, /bin/ping, /bin/nmap' > /etc/sudoers.d/ansible && \
    addgroup ansible && \
    adduser -S ansible -G ansible && \
    mkdir -p /ansible /home/ansible/.ssh && \
    chown -R ansible:ansible /ansible /home/ansible && \
    chmod 700 /home/ansible/.ssh && \
    rm -rf /var/cache/apk/* /root/.cache  # Cleanup step

# Switch to the non-root user 'ansible' and set the working directory.
USER ansible
WORKDIR /ansible

# Set the entry point for the container.
# This is the command that will be run when the container starts.
ENTRYPOINT ["python3", "/usr/local/bin/entrypoint.py"]
