.PHONY: mariadb

export SHELL:=/bin/bash
export BASE_NAME:=$(shell basename ${PWD})
export IMAGE_BASE_NAME:=kz/$(shell basename ${PWD})
export NETWORK:=${BASE_NAME}-network

default: help

help: ## Prints help for targets with comments
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' ${MAKEFILE_LIST} | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
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

mariadb-insert-primary: ## Insert example row to `example`.`primary` table
	@docker exec -it ${BASE_NAME}-mariadb sh -c "mysql -uroot -ppassword example < /mnt/insert-primary.sql"

mariadb-insert-secondary: ## Insert example row to `example`.`secondary` table
	@docker exec -it ${BASE_NAME}-mariadb sh -c "mysql -uroot -ppassword example < /mnt/insert-secondary.sql"

mariadb-insert-tertiary: ## Insert example row to `example`.`tertiary` table
	@docker exec -it ${BASE_NAME}-mariadb sh -c "mysql -uroot -ppassword example < /mnt/insert-tertiary.sql"

#########
# Kafka #
#########

kafka: ## Access kafka container
	@docker exec -it ${BASE_NAME}-kafka bash

kafka-topic-list: ## List Kafka topics
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-topics.sh --list --bootstrap-server ${BASE_NAME}-kafka:9092"

kafka-connect-connectors: ## Connect database connectors
	@docker exec -it ${BASE_NAME}-connect sh -c "/docker-entrypoint-init.d/connect.sh"

kafka-consume-example-primary: ## Consume `example`.`primary` table events
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-console-consumer.sh --topic ${BASE_NAME}-mariadb.example.primary --from-beginning --bootstrap-server ${BASE_NAME}-kafka:9092"

kafka-consume-example-secondary: ## Consume `example`.`primary` table events
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-console-consumer.sh --topic ${BASE_NAME}-mariadb.example.secondary --from-beginning --bootstrap-server ${BASE_NAME}-kafka:9092"

kafka-consume-example-tertiary: ## Consume `example`.`primary` table events
	@docker exec -it ${BASE_NAME}-kafka sh -c "/kafka/bin/kafka-console-consumer.sh --topic ${BASE_NAME}-mariadb.example.tertiary --from-beginning --bootstrap-server ${BASE_NAME}-kafka:9092"

###############
# Danger Zone #
###############

reset: ## Cleanup
	@docker stop $(shell docker ps -aq) || true
	@docker system prune || true
	@docker volume rm $(shell docker volume ls -q) || true
