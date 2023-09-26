# Variables
# The name of the Docker image you want to build.
DOCKER_IMAGE_NAME = ansible
# The tag you want to assign to the Docker image.
DOCKER_TAG = latest

# Targets

# Build the Docker container.
# This target will build the Docker image using the specified name and tag.
build:
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .

# Run the Docker container.
# This target will run the Docker container. The container will be removed after you exit it.
run:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

# Start a shell in the Docker container.
# This target allows you to start a shell session in the Docker container.
shell:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) /bin/sh

# Remove the Docker container and image.
# This target will forcibly remove the Docker image specified by DOCKER_IMAGE_NAME and DOCKER_TAG.
clean:
	@docker rmi -f $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

# Show this help text.
# This target will display a help message showing available targets and their descriptions.
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
