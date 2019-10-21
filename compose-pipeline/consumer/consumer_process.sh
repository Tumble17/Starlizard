#!/bin/bash

export PROCESS="CONSUMER PROCESS"
export CONSUMER_FILE=kafka_consumer.py

echo "$PROCESS: Starting consumer"
python3 $CONSUMER_FILE
