#!/bin/bash

echo "=== Test réseau SOC ==="

echo "[1] ES-NODE-01"
ping -c 2 192.168.100.10

echo
echo "[2] ES-NODE-02"
ping -c 2 192.168.100.11

echo
echo "[3] Transport Elasticsearch ES-NODE-01"
nc -vz 192.168.100.10 9300

echo
echo "[4] Transport Elasticsearch ES-NODE-02"
nc -vz 192.168.100.11 9300