#!/bin/bash

set -m

echo "SINGLE PROCESS STARTED"

. ./broker/broker_process.sh &

# Assign the current process
process_broker=$!
# Wait for the Kafka cluster to form
wait $process_broker

. ./producer/producer_process.sh &

# Don't need to wait for process, start loading consumer whilst producer loads in background
echo "LOADING CONSUMER"

. ./consumer/consumer_process.sh

echo "SINGLE PROCESS COMPLETE"
