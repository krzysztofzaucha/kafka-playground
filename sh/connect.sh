#!/bin/sh

curl -i -X POST \
  -H "accept: application/json" \
  -H "content-type: application/json" "${HOST_NAME}:8083/connectors/" \
  -d '@/docker-entrypoint-init.d/example.json'

printf "\n"
