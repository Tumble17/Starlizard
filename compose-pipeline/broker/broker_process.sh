#!/bin/bash

export PROCESS="KAFKA BROKER PROCESS"
export KAFKA_HOME_LOCATION=$KAFKA_HOME

echo "$PROCESS: Starting process"

echo "$PROCESS: Changing directory to Kafka home location"
cd $KAFKA_HOME_LOCATION

echo "$PROCESS: Stopping lingering Kafka server"
bin/kafka-server-stop.sh || echo "$PROCESS: No Kafka server to stop" &

# Assign current process
process_stop_kafka=$!
# Wait for the step to complete
wait $process_stop_kafka

echo "$PROCESS: Stopping lingering zookeeper server"
bin/zookeeper-server-stop.sh || echo "$PROCESS: No zookeeper server to stop" &

# Assign the current process
process_stop_zookeeper=$!
# Wait for the step to complete
wait $process_stop_zookeeper

echo "$PROCESS: Starting fresh zookeeper server"
bin/zookeeper-server-start.sh config/zookeeper.properties &

# Wait 5 seconds for the zookeeper to start up
echo "$PROCESS: Waiting 5 seconds for zookeeper"
sleep 5

echo "$PROCESS: Starting Kafka server"
bin/kafka-server-start.sh config/server.properties &

echo "$PROCESS: Waiting 5 seconds for Kafka"
sleep 5

echo "$PROCESS: Creating topic"
bin/kafka-topics.sh --create \
	--zookeeper localhost:2181 \
	--replication-factor 1 \
	--partitions 1 \
	--topic prices-topic

echo "$PROCESS: Verifying new topic available"
bin/kafka-topics.sh --list \
	--zookeeper localhost:2181

echo "$PROCESS: Completed process"
