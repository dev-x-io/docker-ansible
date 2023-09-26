# Usage Guide for Docker-Ansible 🐳

This document provides detailed instructions on how to use the `docker-ansible` container using Docker commands.

## Table of Contents

- [Building the Image](#building-the-image)
- [Running the Container](#running-the-container)
- [Binding Playbooks and SSH Keys](#binding-playbooks-and-ssh-keys)
- [⚠️ Important Note on SSH Key Binding ⚠️](#important-note-on-ssh-key-binding)
- [Stopping the Container](#stopping-the-container)
- [Removing the Container](#removing-the-container)

---

## Building the Image

Before you can run the container, you need to build the Docker image. Here's how:

```bash
docker build -t your-username/docker-ansible:latest .
```

Replace `your-username` with your DockerHub username or another name if you're not planning to push the image to DockerHub.

---

## Running the Container

To run the `docker-ansible` container:

```bash
docker run -it --name ansible_container your-username/docker-ansible:latest
```

---

## Binding Playbooks and SSH Keys

To make your local playbooks and SSH keys available inside the container:

1. **Bind your playbooks**:

   Append `-v /path/to/your/local/playbooks:/ansible/playbooks` to the `docker run` command.

   Example:

   ```bash
   docker run -it -v /path/to/your/local/playbooks:/ansible/playbooks --name ansible_container your-username/docker-ansible:latest
   ```

2. **Bind your SSH keys**:

   Append `-v /path/to/your/local/.ssh/ansible:/home/ansible/.ssh` to the `docker run` command.

   Example:

   ```bash
   docker run -it -v /path/to/your/local/.ssh:/home/ansible/.ssh --name ansible_container your-username/docker-ansible:latest
   ```

You can combine both bindings:

```bash
docker run -it -v /path/to/your/local/playbooks:/ansible/playbooks -v /path/to/your/local/.ssh:/home/ansible/.ssh/ --name ansible_container your-username/docker-ansible:latest
```

---

## ⚠️ Important Note on SSH Key Binding ⚠️

When binding your SSH keys from your local system to the container, it's crucial to be aware of security implications. The keys inside the container will inherit permissions and ownership settings from the host system. However, any changes to permissions or ownership within the container can reflect back onto your local system, potentially compromising the security of your keys.

### Recommendations:

1. **Use a Temporary Subdirectory**: Instead of binding your entire `~/.ssh` directory, consider using a temporary subdirectory to store the keys that you intend to use with the container. This ensures that other keys remain untouched.

   For example, you could organize it like this:
   ```
   ~/.ssh/
   ├── id_rsa
   ├── id_rsa.pub
   └── docker_ansible/
       ├── id_rsa_docker_ansible
       └── id_rsa_docker_ansible.pub
   ```
   Then bind only the `docker_ansible` subdirectory to the container.

   ```bash
   docker run -it -v /path/to/your/local/.ssh/docker_ansible:/home/ansible/.ssh --name ansible_container your-username/docker-ansible:latest
   ```

2. **Check Ownership and Permissions**: After running the container, double-check the ownership and permissions of your SSH keys on your local system to ensure they haven't been altered.

Please exercise caution and make sure you understand the risks before proceeding.

---

## Stopping the Container

To stop the `docker-ansible` container:

```bash
docker stop ansible_container
```

---

## Removing the Container

If you need to remove the container:

```bash
docker rm ansible_container
```

We hope this guide provides clarity on how to use the `docker-ansible` container with Docker commands. If you encounter any issues or have further questions, please refer to the main `README.md` or open an issue.
