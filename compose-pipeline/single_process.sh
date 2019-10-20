#!/bin/bash

set -m

echo "SINGLE PROCESS STARTED"

. ./broker/broker_process.sh &

. ./producer/producer_process.sh &

. ./consumer/consumer_process.sh

echo "SINGLE PROCESS COMPLETE"
