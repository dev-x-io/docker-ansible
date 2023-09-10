# Usage Guide for Docker-Ansible 🐳

This document provides detailed instructions on how to use the `docker-ansible` container using Docker commands.

## Table of Contents

- [Building the Image](#building-the-image)
- [Running the Container](#running-the-container)
- [Binding Playbooks and SSH Keys](#binding-playbooks-and-ssh-keys)
- [Stopping the Container](#stopping-the-container)
- [Removing the Container](#removing-the-container)

## Building the Image

Before you can run the container, you need to build the Docker image. Here's how:

```bash
docker build -t your-username/docker-ansible:latest .
```

Replace `your-username` with your DockerHub username or another name if you're not planning to push the image to DockerHub.

## Running the Container

To run the `docker-ansible` container:

```bash
docker run -it --name ansible_container your-username/docker-ansible:latest
```

## Binding Playbooks and SSH Keys

To make your local playbooks and SSH keys available inside the container:

1. **Bind your playbooks**:

   Append `-v /path/to/your/local/playbooks:/ansible/playbooks` to the `docker run` command.

   Example:

   ```bash
   docker run -it -v /path/to/your/local/playbooks:/ansible/playbooks --name ansible_container your-username/docker-ansible:latest
   ```

2. **Bind your SSH keys**:

   Append `-v /path/to/your/local/.ssh:/home/ansible/.ssh` to the `docker run` command.

   Example:

   ```bash
   docker run -it -v /path/to/your/local/.ssh:/home/ansible/.ssh --name ansible_container your-username/docker-ansible:latest
   ```

You can combine both bindings:

```bash
docker run -it -v /path/to/your/local/playbooks:/ansible/playbooks -v /path/to/your/local/.ssh:/home/ansible/.ssh/ --name ansible_container your-username/docker-ansible:latest
```

## Stopping the Container

To stop the `docker-ansible` container:

```bash
docker stop ansible_container
```

## Removing the Container

If you need to remove the container:

```bash
docker rm ansible_container
```

---

We hope this guide provides clarity on how to use the `docker-ansible` container with Docker commands. If you encounter any issues or have further questions, please refer to the main `README.md` or open an issue.
