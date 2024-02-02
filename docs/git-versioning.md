# Git Versioning Workflow 🚀

[![GitHub Actions Status](https://github.com/dev-x-io/docker-ansible/actions/workflows/git-versioning.yml/badge.svg)](https://github.com/dev-x-io/docker-ansible/actions/workflows/git-versioning.yml)

Welcome to the Git Versioning Workflow in the `docker-ansible` repository! This workflow automates the versioning of the repository based on the state of pull requests merged into the `develop` branch. It follows a structured versioning scheme and helps manage the project's version numbers efficiently.

## How Git Versioning Works

The Git Versioning Workflow automates the versioning process using the following rules:

- **Major (X) Version**: Incremented when the latest commit message includes "do-major-update".
- **Minor (Y) Version**: Incremented based on the number of successfully merged feature pull requests since the last version tag.
- **Patch (Z) Version**: Incremented based on the number of successfully merged bugfix pull requests since the last version tag.

## Workflow Triggers

The workflow is triggered on every pull request to the `develop` branch. It analyzes the pull requests and commits to determine the appropriate version bump.

## Workflow Steps

1. **Retrieve Latest Tag**: The workflow retrieves the latest tag from the repository to determine the current major, minor, and patch versions.
2. **Fetch Latest Commit Message**: The latest commit message is fetched to determine if a major version bump is necessary.
3. **Calculate Version Bump**: Based on the pull requests and commits since the last tag, the workflow calculates the version bump required for the next release.
4. **Set New Version**: The workflow sets the new version number in the repository, considering the calculated version bump.

## Example Scenario

- You merge several feature and bugfix pull requests into the `develop` branch.
- Your latest commit message states "do-major-update".
- The workflow calculates the increments for major, minor, and patch versions accordingly.
- The repository is now tagged with the new version, e.g., `v2.3.4`.

## Customize the Workflow

You can customize this workflow to fit your project's versioning scheme and branching strategy. Adjust the rules and calculations in the workflow YAML file to match your requirements.

For more details on how the Git Versioning Workflow operates and how to configure it, refer to the [workflow YAML file](.github/workflows/git-versioning.yml) in the `.github/workflows/` directory.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file. Please review it for more details.

---

Thank you for using the Git Versioning Workflow in `docker-ansible`. We hope it streamlines your version management and makes releases smoother! 🌟
