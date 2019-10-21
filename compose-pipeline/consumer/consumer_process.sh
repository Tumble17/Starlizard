#!/bin/bash

export PROCESS="CONSUMER PROCESS"
export CUR_DIR=$PWD
export CONSUMER_FILE=kafka_consumer.py

echo "$PROCESS: Starting consumer"
python3 $CUR_DIR/$CONSUMER_FILE
