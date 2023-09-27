# Docker-Ansible 🐳

[![Docker CI/CD](https://github.com/dev-x-io/docker-ansible/actions/workflows/ci.yml/badge.svg)](https://github.com/dev-x-io/docker-ansible/actions/workflows/ci.yml)

![Dev-X.io Logo](img/logo.png)

"The best way to predict the future is to invent it." - Alan Kay

Current version: v0.0.6

Welcome to the `docker-ansible` repository! This project aims to provide a Docker container equipped with Ansible, ready for action. Whether you're looking to test locally, develop, or simply have a standardized Ansible environment, you're in the right place!

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Build Methods Comparison](#build-methods-comparison)
- [GitHub Actions](#github-actions)
- [Contributing](#contributing)
- [License](#license)

## Features

- Lightweight container based on Alpine.
- Ansible installed and configured for immediate use.
- Additional tools to enhance your Ansible experience.
- A convenient entry point script to handle various startup scenarios.

## Getting Started

### Clone the Repository

You have two options to get the source code:

1. **Using Git**: 
    ```bash
    git clone https://github.com/your_username/docker-ansible.git
    cd docker-ansible
    ```

2. **Downloading ZIP**: Alternatively, you can [download the ZIP file](https://github.com/your_username/docker-ansible/archive/refs/heads/main.zip) from the GitHub page.

### Build the Docker Image

Choose one of the following methods to build the Docker image:

1. **Using Docker Compose**: 
    ```bash
    docker-compose build
    ```

2. **Using Makefile**: 
    ```bash
    make build
    ```

### Run the Container

To run the container, use one of the following methods:

1. **Using Docker Compose**: 
    ```bash
    docker-compose up
    ```

2. **Using Makefile**: 
    ```bash
    make run
    ```

## Usage

If you're new to Docker or need a refresher on how to use the `docker-ansible` container, don't worry, we've got you covered! Check out our [docs/USAGE.md](docs/USAGE.md) guide in the `docs/` directory. This document provides step-by-step instructions on building, running, and managing the Docker container, including how to bind your own playbooks and SSH keys.

### Important Note on SSH Keys

Binding your SSH keys to the container has some security implications. Please read the relevant section in [docs/USAGE.md](docs/USAGE.md) for more information.

## Build Methods Comparison

| Method          | Complexity | Flexibility | Best For                    |
|-----------------|------------|-------------|-----------------------------|
| Docker Compose  | Easy       | Moderate    | Quick and easy setups       |
| Makefile        | Moderate   | High        | Customizable build scenarios|

## GitHub Actions

Our GitHub Actions workflow automates the build and push process for our Docker images. Here's what each job does:

- **Docker**: Runs on the latest version of Ubuntu and performs several tasks including setting up Docker, logging in to DockerHub, and pushing the Docker image. For more details, check the workflow YAML in the `.github/workflows/` directory.

## Contributing

We appreciate your enthusiasm! If you'd like to contribute to this project, please review our [CONTRIBUTING.md](docs/CONTRIBUTING.md) guidelines.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file. Please review it for more details.

---

Thank you for your interest in `docker-ansible`. We look forward to your contributions and hope you find this tool beneficial! 🚀
