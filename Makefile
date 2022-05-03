.PHONY: mariadb

export SHELL:=/bin/bash
export BASE_NAME:=$(shell basename ${PWD})
export IMAGE_BASE_NAME:=kz/$(shell basename ${PWD})
export NETWORK:=${BASE_NAME}-network

default: help

help: ## Prints help for targets with comments
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

#######
# Run #
#######

compose:
	@docker-compose ${COMPOSE} \
		-p ${BASE_NAME} \
		up --build --force-recreate --remove-orphans --abort-on-container-exit

up: ## Start the example
	@COMPOSE=" -f docker-compose.yml" make compose

###########
# MariaDB #
###########

mariadb: ## Access MariaDB shell
	@docker exec -it ${BASE_NAME}-mariadb mysql -uroot -ppassword

#########
# Kafka #
#########

kafka: ## Access kafka container
	@docker exec -it ${BASE_NAME}-kafka bash

kafka-topic-list: ## List Kafka topics
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-topics.sh --list --bootstrap-server ${BASE_NAME}-kafka:9092"

kafka-connect-example: ## Connect `example` database
	@curl -i -X POST \
		-H "accept: application/json" \
		-H "content-type: application/json" localhost:8083/connectors \
		-d '@config/example.json'

kafka-consume-example-example: ## Consume `example`.`example` table events
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-console-consumer.sh --topic ${BASE_NAME}-mariadb.example.example --from-beginning --bootstrap-server ${BASE_NAME}-kafka:9092"

###############
# Danger Zone #
###############

reset: ## Cleanup
	@docker stop $(shell docker ps -aq)
	@docker system prune
	@docker volume rm $(shell docker volume ls -q)
