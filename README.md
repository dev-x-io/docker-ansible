# Docker-Ansible 🐳

![Dev-X.io Logo](img/logo.png)

Welcome to the `docker-ansible` repository! This project aims to provide a Docker container equipped with Ansible, ready for action. Whether you're looking to test locally, develop, or simply have a standardized Ansible environment, you're in the right place!

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- Lightweight container based on Alpine.
- Ansible installed and configured for immediate use.
- Additional tools to enhance your Ansible experience.
- A convenient entry point script to handle various startup scenarios.

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/dev-x-io/docker-ansible.git
   cd docker-ansible
   ```

2. **Build the Docker Image**:

   ```bash
   docker-compose build
   ```

3. **Run the Container**:

   ```bash
   docker-compose up
   ```

## Usage

If you're new to Docker or need a refresher on how to use the `docker-ansible` container, we've got you covered! Check out our [docs/USAGE.md](docs/USAGE.md) guide in the `docs/` directory. This document provides step-by-step instructions on building, running, and managing the Docker container, including how to bind your own playbooks and SSH keys.

If you have specific playbooks or configurations, place them in the respective folders as detailed in the directory structure.

Once the container is up and running, you can execute Ansible commands as you would in a typical environment. The provided `docker-compose.yml` ensures that your local Ansible directory is bound to the container, enabling real-time development and testing.

## Contributing

We appreciate your enthusiasm! If you'd like to contribute to this project, please review our [CONTRIBUTING.md](docs/CONTRIBUTING.md) guidelines.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file. Please review it for more details.

---

Thank you for your interest in `docker-ansible`. We look forward to your contributions and hope you find this tool beneficial! 🚀
