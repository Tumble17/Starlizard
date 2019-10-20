#!/bin/bash

echo "ZOOKEEPER PROCESS"

KAFKA_LOCATION = /home/kafka/kafka

sudo $KAFKA_LOCATION/bin/zookeeper-server-stop.sh
sudo $KAFKA_LOCATION/bin/zookeeper-server-start.sh $KAFKA_LOCATION/config/zookeeper.properties
