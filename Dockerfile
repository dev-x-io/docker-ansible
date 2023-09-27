# Start with a lightweight base image (Alpine Linux).
# We're using a multi-stage build process. This is the "build" stage.
FROM alpine:3.18.3 AS build

# Copy the Python script that will be the entry point of our application.
# This makes it available for further stages.
COPY apps/entrypoint.py /usr/local/bin/

# Install essential packages and Python libraries, then clean up to reduce image size.
RUN apk add --no-cache python3 && \
    chmod +x /usr/local/bin/entrypoint.py  # Make the script executable

# This is the final stage, where we gather only the artifacts we need.
FROM alpine:3.18.3 AS final

# Declare and set a version environment variable.
ARG APP_VERSION=v0.0.0
ENV APP_VERSION=${APP_VERSION}

# Copy essential files from the previous stage.
COPY --from=build /usr/local/bin/entrypoint.py /usr/local/bin/entrypoint.py

# Install only the necessary packages to run our application.
RUN apk add --no-cache python3 ansible nmap openssh sudo && \
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
ENTRYPOINT ["python3", "/usr/local/bin/entrypoint.py"]
CMD []
