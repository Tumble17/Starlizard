#!/bin/bash

export PROCESS="KAFKA BROKER PROCESS"
export KAFKA_HOME_LOCATION=/home/kafka

echo "$PROCESS: Starting process"

echo "$PROCESS: Changing directory to Kafka home location"
cd $KAFKA_HOME_LOCATION

echo "$PROCESS: Stopping lingering Kafka server"
kafka/bin/kafka-server-stop.sh || echo "$PROCESS: No Kafka server to stop" &

# Assign current process
process_stop_kafka=$!
# Wait for the step to complete
wait $process_stop_kafka

echo "$PROCESS: Stopping lingering zookeeper server"
kafka/bin/zookeeper-server-stop.sh || echo "$PROCESS: No zookeeper server to stop" &

# Assign the current process
process_stop_zookeeper=$!
# Wait for the step to complete
wait $process_stop_zookeeper

echo "$PROCESS: Starting fresh zookeeper server"
/usr/bin/sudo kafka/bin/zookeeper-server-start.sh kafka/config/zookeeper.properties &

# Assign the current process
process_start_zookeeper=$!
# Wait for the step to complete
wait $process_start_zookeeper

echo "$PROCESS: Starting Kafka server"
kafka/bin/kafka-server-start.sh kafka/config/server.properties &

echo "$PROCESS: Creating topic"
kafka/bin/kafka-topics.sh --create \
	--zookeeper localhost:2181 \
	--replication-factor 1 \
	--partitions 1 \
	--topic prices-topic

echo "$PROCESS: Verifying new topic available"
kafka/bin/kafka-topics.sh --list \
	--zookeeper localhost:2181

echo "$PROCESS: Completed process"
