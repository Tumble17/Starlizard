FROM spotify/kafka:latest
USER root
COPY . .
RUN bash broker_process.sh &
RUN process_broker=$!
RUN wait $process_broker
