# Variabelen
DOCKER_IMAGE_NAME = ansible
DOCKER_TAG = latest

# Targets

## build: Bouwt de Docker container.
build:
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) .

## run: Draait de Docker container.
run:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

## shell: Start een shell in de Docker container.
shell:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_TAG) /bin/sh

## clean: Verwijdert de Docker container en image.
clean:
	@docker rmi -f $(DOCKER_IMAGE_NAME):$(DOCKER_TAG)

## help: Toont deze hulptekst.
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
