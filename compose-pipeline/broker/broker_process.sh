#!/bin/bash

export PROCESS="KAFKA BROKER PROCESS"
export KAFKA_HOME_LOCATION=/home/kafka

echo "$PROCESS: Starting process"

echo "$PROCESS: Changing directory to kafka home location"
cd $KAFKA_HOME_LOCATION

echo "$PROCESS: Stopping lingering zookeeper server"
# . kafka/bin/zookeeper-server-stop.sh || echo "$PROCESS: No zookeeper server to stop"

echo "$PROCESS: Starting fresh zookeeper server"
sudo . kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties &

echo "$PROCESS: Starting Kafka server"
. kafka/bin/kafka-server-start.sh kafka/config/server.properties &

echo "$PROCESS: Creating topic"
. kafka/bin/kafka-topics.sh --create \
	--zookeeper localhost:2181 \
	--replication-factor 1 \
	--partitions 1 \
	--topic prices-topic

echo "$PROCESS: Verifying new topic available"
. kafka/bin/kafka-topics.sh --list \
	--zookeeper localhost:2181

echo "$PROCESS: Completed process"
