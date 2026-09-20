#!/bin/bash

ES_URL="https://192.168.100.10:9200"

echo "=== Elasticsearch nodes ==="
curl -k -u elastic "$ES_URL/_cat/nodes?v"

echo
echo "=== Cluster health ==="
curl -k -u elastic "$ES_URL/_cluster/health?pretty"