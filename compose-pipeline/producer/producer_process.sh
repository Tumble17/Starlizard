#!/bin/bash

export PROCESS="PRODUCER PROCESS"
export PRODUCER_FILE=json_producer.py
export CUR_DIR=$PWD

echo "$PROCESS: Starting producer"
if [[ $CUR_DIR == *"/producer"* ]]; then 
	echo "$PROCESS: Producer started in test mode"
	python3 $PRODUCER_FILE 
else
	echo "$PROCESS: Producer started in prod mode"
	python3 ./producer/$PRODUCER_FILE

fi
