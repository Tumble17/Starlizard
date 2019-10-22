FROM spotify/kafka:latest
USER root
RUN apt-get update; apt-get -y install python3-pip
COPY . .
COPY ./config/zookeeper.properties $KAFKA_LOCATION/config/zookeeper.properties
COPY ./config/server.properties $KAFKA_LOCATION/config/server.properties
RUN pip3 install -r requirements.txt
RUN bash single_process.sh
