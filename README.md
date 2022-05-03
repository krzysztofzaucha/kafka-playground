# Kafka Sandbox

This repository contains basic Kafka, Kafka Connect and MariaDB configuration.

## Makefile

Use `Makefile` to run all the examples. To list all available options use `make`.

## Instructions

- Run `make up` to start everything up.
- Run `make kafka-connect-example` to configure `example` database connector.
- Run `make mariadb` to access database shell, then `USE example; INSERT INTO example(example) VALUES ("Hello World!");`.
- Run `make kafka-consume-example-example` to see coming events.

## Kafka

Call the following from the host machine.

```bash
curl -i -X POST \
  -H "accept: application/json" \
  -H "content-type: application/json" localhost:8083/connectors \
  -d '@config/example.json'

curl -i -X GET -H "accept: application/json" localhost:8083/connectors

curl -i -X DELETE -H "accept: application/json" localhost:8083/connectors/<CONNECTOR_NAME>
```

The following commands must be called from the Kafka container.

```bash
kafka-console-consumer.sh --topic kafka-sandbox-mariadb --from-beginning --bootstrap-server kafka-sandbox-kafka:9092
kafka-console-consumer.sh --topic kafka-sandbox-mariadb.example.example --from-beginning --bootstrap-server kafka-sandbox-kafka:9092
```

## MariaDB

```sql
INSERT INTO `example`(`example`) VALUES ("Hello World!");
```
