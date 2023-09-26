# Variables
DOCKER_IMAGE_NAME = ansible  # Name of the Docker image
DOCKER_TAG = latest  # Tag for the Docker image

# Targets

## build: Build the Docker container.
build:
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .  # Build the Docker image with the given name and tag.

## run: Run the Docker container.
run:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)  # Run the Docker container and remove it after exiting.

## shell: Start a shell in the Docker container.
shell:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) /bin/sh  # Start a shell session in the Docker container.

## clean: Remove the Docker container and image.
clean:
	@docker rmi -f $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)  # Force remove the Docker image.

## help: Show this help text.
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'  # Show the available commands and their description.
