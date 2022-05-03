# Kafka Sandbox

This repository contains basic Kafka, Kafka Connect and MariaDB configuration.

## Kafka

```bash
curl -i -X POST \
  -H "accept: application/json" \
  -H "content-type: application/json" localhost:8083/connectors \
  -d '@config/example.json'

curl -i -X GET -H "accept: application/json" localhost:8083/connectors

curl -i -X DELETE -H "accept: application/json" localhost:8083/connectors/<CONNECTOR_NAME>

kafka-console-consumer.sh --topic kafka-sandbox-mariadb --from-beginning --bootstrap-server kafka-sandbox-kafka:9092
kafka-console-consumer.sh --topic kafka-sandbox-mariadb.example.example --from-beginning --bootstrap-server kafka-sandbox-kafka:9092
```

## MariaDB

```sql
INSERT INTO `example`(`example`) VALUES ("Hello World!");
```
