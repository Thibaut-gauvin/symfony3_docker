###################################
#      MAKEFILE FOR PROJECT       #
###################################

.SILENT:
.PHONY: build

# If you want to run a comand for the prod environment,
# Simply add "-e env=prod" at the end of your make command
#
# Example:
# $ make start -e env=prod

# dev is the default environment, it use the docker-compose.yml file
# prod use the docker-compose-prod.yml file
env ?= dev

ifeq ($(env),prod)
CONFIG = docker-compose-prod.yml
else
CONFIG = docker-compose.yml
endif

COMPOSE_CMD = docker-compose -f$(CONFIG)

#####
# Executed when you run "make" cmd
# Simply run "start" tasks
all: start

#####
# Start containers (Also builds images, if there not exists)
start:
	$(COMPOSE_CMD) up -d

#####
# Stop containers
stop:
	$(COMPOSE_CMD) down

#####
# List current running containers
list:
	$(COMPOSE_CMD) ps

#####
# Display current running containers logs (Press "Ctrl + c" to exit)
logs:
	$(COMPOSE_CMD) logs -f

#####
# Execute "start" tasks and run provisioning scripts
init: start
	$(COMPOSE_CMD) run symfony /bin/sh -ec '/entrypoint.sh'

#####
# Start new bash terminal inside the Symfony Container
ssh:
	$(COMPOSE_CMD) run symfony bash

#####
# Run the PhpMetrics analysis and output "report.html"
metrics:
	$(COMPOSE_CMD) run symfony phpmetrics --report-html=report.html /home/docker/src

#####
# Run the PhpMetrics analysis and output "report.html"
documentation:
	$(COMPOSE_CMD) run symfony phpDocumentor -d src/ -t doc/

#####
# Run the entire Unitary & Functional PhpUnit tests
tests:
	$(COMPOSE_CMD) run symfony vendor/bin/phpunit -c app/phpunit.xml.dist

#####
# Execute "make" cmd & give environment variable "env" = prod
# This will results to start containers using configs & services described in "docker-compose-prod.yml" file
prod:
	make -e env=prod

#####
# Remove stopped container
clean-container:
	$(COMPOSE_CMD) rm --force

#####
# Display available make commands
help:
	@echo 'Recipes List:'
	@echo ''
	@echo 'run make <recipes>'
	@echo ''
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo '| Recipes         | Utility                                                            |'
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo '| start           | Start containers (Also builds images, if there not exists)         |'
	@echo '| stop            | Stop containers (And also remove it)                               |'
	@echo '| list            | List current running containers                                    |'
	@echo '| init            | Execute "start" tasks and run provisioning scripts                 |'
	@echo '| ssh             | Start new bash terminal inside the Symfony Container               |'
	@echo '| metrics         | Run the PhpMetrics analysis (output report.html)                   |'
	@echo '| documentation   | Generated PhpDoc with phpDocumentor                                |'
	@echo '| tests           | Execute the entire Unitary & Functional PhpUnit tests suit         |'
	@echo '| logs            | Display current running containers logs (Press "Ctrl + c" to exit) |'
	@echo '| prod            | Execute "make" cmd & give environment variable "env" = prod        |'
	@echo '| clean-container | Remove stopped useless containers                                  |'
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo ''
