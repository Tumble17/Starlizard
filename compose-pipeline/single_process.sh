#!/bin/bash

set -m

echo "SINGLE PROCESS STARTED"

. ./broker/broker_process.sh &

# Assign the current process
process_broker=$!
# Wait for the Kafka cluster to form
wait $process_broker

. ./producer/producer_process.sh &

# Assign the current process
process_producer=$!
# Wait for the producer to load
wait $process_producer

. ./consumer/consumer_process.sh

echo "SINGLE PROCESS COMPLETE"
