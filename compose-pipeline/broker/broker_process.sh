#!/bin/bash

export PROCESS="KAFKA BROKER PROCESS"
export KAFKA_LOCATION=/home/kafka/kafka

echo "$PROCESS: Starting process"

echo "$PROCESS: Stopping lingering zookeeper server"
. $KAFKA_LOCATION/bin/zookeeper-server-stop.sh

echo "$PROCESS: Starting fresh zookeeper server"
. $KAFKA_LOCATION/bin/zookeeper-server-start.sh $KAFKA_LOCATION/config/zookeeper.properties &

echo "$PROCESS: Starting Kafka server"
. $KAFKA_LOCATION/bin/kafka-server-start.sh $KAFKA_LOCATION/config/server.properties &

echo "$PROCESS: Creating topic"
. $KAFKA_LOCATION/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic prices-topic

echo "$PROCESS: Verifying new topic available"
. $KAFKA_LOCATION/bin/kafka-topics.sh --list --zookeeper localhost:2181

echo "$PROCESS: Completed process"
