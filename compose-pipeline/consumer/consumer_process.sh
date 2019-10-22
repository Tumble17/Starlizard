#!/bin/bash

export PROCESS="CONSUMER PROCESS"
export CONSUMER_FILE=kafka_consumer.py
export CUR_DIR=$PWD

echo "$PROCESS: Starting consumer"
if [[ $CUR_DIR == *"/consumer"* ]]; then
	echo "$PROCESS: Consumer started in test mode"
	python3 $CONSUMER_FILE
else
	echo "$PROCESS: Consumer started in prod mode"
	python3 ./consumer/$CONSUMER_FILE
fi
