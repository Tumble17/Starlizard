#!/bin/bash

export PROCESS="CONSUMER PROCESS"
export CUR_DIR=$PWD
export CONSUMER_FILE=kafka_consumer.py

echo "$PROCESS: Starting consumer"
python3 $CUR_DIR/$CONSUMER_FILE

# Start the consumer. Attempts the passed path from the single_process.sh script
# When it fails it moves to running the path from the same folder fire
if [[ $CUR_DIR == *"/consumer"* ]]; then
	echo "$PROCESS: Consumer started in test mode"
	python3 $CUR_DIR/$CONSUMER_FILE
else
	echo "$PROCESS: Consumer started in prod mode"
	python3 $CUR_DIR/consumer/$CONSUMER_FILE
fi
