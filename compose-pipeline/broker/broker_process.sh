#!/bin/bash

PROCESS = "KAFKA BROKER PROCESS"
KAFKA_LOCATION = /home/kafka/kafka

echo "$PROCESS: Starting process"

echo "$PROCESS: Starting Kafka server"
sudo $KAFKA_LOCATION/bin/kafka-server-start.sh $KAFKA_LOCATION/config/server.properties

echo "$PROCESS: Creating topic"
sudo $KAFKA_LOCATION/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic prices-topic

echo "$PROCESS: Verifying new topic available"
sudo $KAFKA_LOCATION/bin/kafka-topics.sh --list --zookeeper localhost:2181

echo "$PROCESS: Complete"
