######################################
##       MAKEFILE FOR PROJECT       ##
######################################

.SILENT:
.PHONY: tests build

-include .env
export

## If you want to run a comand for the prod environment,
## Simply replace value of ENV variable in '.env' file

## dev is the default environment, it use the docker-compose.yml file
## prod use the docker-compose-prod.yml file
ENV ?= dev

ifeq ($(ENV),prod)
CONFIG = docker-compose-prod.yml
else
CONFIG = docker-compose.yml
endif

COMPOSE_CMD = docker-compose -f$(CONFIG)

#####
## Executed when you run "make" cmd
## Simply run "help" tasks
all: help

#####
## Build images (and ensure they are up to date)
build:
	@echo 'Pull & build required images for [$(ENV)] mode'
	$(COMPOSE_CMD) build

#####
## Start containers
start:
	@echo 'Starting containers in [$(ENV)] mode'
	$(COMPOSE_CMD) up -d

#####
## Stop containers & remove docker networks
stop:
	@echo 'Stoping containers in [$(ENV)] mode'
	$(COMPOSE_CMD) down

#####
## List current running containers services
list:
	@echo 'List containers in [$(ENV)] mode'
	$(COMPOSE_CMD) ps

#####
## Display current running containers logs (Press "Ctrl + c" to exit)
logs:
	@echo 'Log containers in [$(ENV)] mode'
	$(COMPOSE_CMD) logs -f

#####
## Start new bash terminal inside the Symfony Container
ssh:
	@echo 'SSH to symfony container in [$(ENV)] mode'
	$(COMPOSE_CMD) run symfony bash

#####
## Execute "build" & "start" tasks and run provisioning scripts
init: build start
ifeq ($(ENV),dev)
	@echo 'Running provisioning scripts'
	$(COMPOSE_CMD) run symfony /bin/sh -ec '/entrypoint.sh'
	make tests
else
	@echo 'This tasks is disabled in [$(ENV)] mode'
endif

#####
## Run the entire Unitary & Functional PhpUnit tests
tests:
ifeq ($(ENV),dev)
	@echo 'Running php tests'
	$(COMPOSE_CMD) run symfony vendor/bin/phpunit -c app/phpunit.xml
	make clean-container
else
	@echo 'This tasks is disabled in [$(ENV)] mode'
endif

#####
## Run the entire tests & code-coverage html report
code-coverage:
ifeq ($(ENV),dev)
	@echo 'Running php tests & generate code-coverage html report'
	$(COMPOSE_CMD) run symfony vendor/bin/phpunit -c app/phpunit.xml --coverage-html coverage/report_$(shell date "+%d-%m-%y-%H:%M")
	make clean-container
else
	@echo 'This tasks is disabled in [$(ENV)] mode'
endif

#####
## Clean symfony cache & logs files
clean-sf-cache:
ifeq ($(ENV),dev)
	@echo 'Remove cache & logs files'
	if [ -d  "./var/cache" ]; then rm -rf ./var/cache; fi;
	if [ -d "./var/logs" ]; then rm -rf ./var/logs; fi;
else
	@echo 'This tasks is disabled in [$(ENV)] mode'
endif

#####
## Remove stopped containers
clean-container:
	@echo 'Remove stopped containers'
	$(COMPOSE_CMD) rm --force

#####
## Display available make tasks
help:
	@echo 'Recipes List:'
	@echo ''
	@echo 'make <recipes>'
	@echo ''
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo '| Recipes         | Utility                                                            |'
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo '| start           | Start containers (Also builds & pull images, if there not exists)  |'
	@echo '| stop            | Stop containers & remove docker networks                           |'
	@echo '| list            | List current running containers                                    |'
	@echo '| ssh             | Start new bash terminal inside the Symfony Container               |'
	@echo '| init            | Execute "start" tasks and run provisioning scripts                 |'
	@echo '| tests           | Execute the entire Unitary & Functional PhpUnit tests suit         |'
	@echo '| code-coverage   | Run the entire tests with code coverage                            |'
	@echo '| logs            | Display current running containers logs (Press "Ctrl + c" to exit) |'
	@echo '| clean-sf-cache  | Clean symfony cache & logs files                                   |'
	@echo '| clean-container | Remove stopped useless containers                                  |'
	@echo '+-----------------+--------------------------------------------------------------------+'
	@echo ''
