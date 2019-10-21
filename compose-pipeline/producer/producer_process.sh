#!/bin/bash

export PROCESS="PRODUCER PROCESS"
export PRODUCER_FILE=json_producer.py

echo "$PROCESS: Starting producer"
python3 $PRODUCER_FILE

