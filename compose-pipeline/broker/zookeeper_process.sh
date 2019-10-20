#!/bin/bash

export PROCESS="ZOOKEEPER PROCESS"
export KAFKA_LOCATION=/home/kafka/kafka

echo "$PROCESS: Starting process"

echo "$PROCESS: Stopping lingering zookeeper server"
. $KAFKA_LOCATION/bin/zookeeper-server-stop.sh

echo "$PROCESS: Starting fresh zookeeper server"
. $KAFKA_LOCATION/bin/zookeeper-server-start.sh $KAFKA_LOCATION/config/zookeeper.properties

echo "$PROCESS: Completed process"
