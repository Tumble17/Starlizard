#!/bin/bash

export PROCESS="PRODUCER PROCESS"
export CUR_DIR=$PWD
export PRODUCER_FILE=json_producer.py

echo "$PROCESS: Starting producer"
# Start the producer. Attempts the passed path from the single_process.sh script
# When it fails it moves to running the path from the same folder fire
if [[ $CUR_DIR == *"/producer"* ]]; then
	echo "$PROCESS: Producer started in test mode"
	python3 $CUR_DIR/$PRODUCER_FILE
else
	echo "$PROCESS: Producer started in prod mode"
	python3 $CUR_DIR/producer/$PRODUCER_FILE
fi

