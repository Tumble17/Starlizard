# Starlizard
A temporary repository for interview purposes only. This repo walks through the steps taken to build a pipeline that comprises of a producer, a kafka broker and a consumer. The spec explicitly asks for Docker Compose as the method of orchestration, alongside Python 3+ and Docker Compose 1.17+.

This README is made up of the following sections:
1. Setup
   
   a. Installs

2. Docker Compose

3. Future Work


---
### Setup

This setup outlines the steps I went through to create a container with the required software for the development of the build. Docker negates this need at production. I also wanted to get into the lowest granularity of the setup before abstracting to Docker Compose and Dockerfile code. This therefore assumes these steps have taken place or are not required in the way that the user works with the end Docker Compose build of the code repo.

#### Installs
##### Install Docker Engine
I installed using the convenience script found at: https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-convenience-script.

```shell
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

##### Install Docker Compose

I installed using the 'Install Compose on Linux systems' walkthrough found at: https://docs.docker.com/compose/install/#install-compose.

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


##### Install pip3
I installed pip3 so that I could install virtual environments (with Python 3+) for development of the separate pipeline components, before passing them to the services within the Docker Compose. https://askubuntu.com/questions/778052/installing-pip3-for-python3-on-ubuntu-16-04-lts-using-a-proxy.

```shell
sudo apt-get update   
sudo apt-get -y install python3-pip
``` 

I also installed virtualenv but did not include this in the requirements file as it's external to the container build.

```shell
sudo apt-get install python3-venv
python3 -m venv pipeline-producer
. pipeline-producer/bin/activate
```
I then use the infamous and lazy trick of saving the developed environment down into the requirements.txt file once happy, using `pip3 freeze > requirements.txt`.

##### Install git
I installed git in order to manage this repo on the raw development linux instance that I was using. https://www.digitalocean.com/community/tutorials/how-to-contribute-to-open-source-getting-started-with-git

```shell
sudo apt-get update
sudo apt-get install git
```

##### Clone Repo
`git clone https://github.com/Tumble17/Starlizard.git` drops the repo into the working directory.

##### Install Kafka
I installed the kafka binaries from https://www.digitalocean.com/community/tutorials/how-to-install-apache-kafka-on-ubuntu-18-04 and processed them. This allowed me to manage the full configuration of the build.

```shell
curl "https://www.apache.org/dist/kafka/2.1.1/kafka_2.11-2.1.1.tgz" -o ~/Starlizard/compose-pipeline/kafka
tar -xvzf kafka.tgz --strip 1
```

##### Install Java 8 JDK
The kafka build relies on Java 8 so I installed from https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04#installing-specific-versions-of-openjdk.

```shell
sudo apt install openjdk-8-jdk
```

---

### Build

##### Producer
I used Python, so leant on the KafkaProducer module to keep things simple. The generation of random numbers is fairly simple in this illustrative example, as I just use `random.randint` for the three digit numbers and `random.uniform` for the decimal placed numerics. 

**NOTE 1** 
Generation of a dictionary and JSON (Python 3.5) is under the CPython implementation, so the schema of:
```javascript
{
  "match" : v1,
  "price" : v2
}
```
could be lost by the lack of order preservation. This is returned for 3.6+. See: [https://stackoverflow.com/questions/1867861/how-to-keep-keys-values-in-same-order-as-declared] and [https://stackoverflow.com/questions/10844064/items-in-json-object-are-out-of-order-using-json-dumps]. Therefore I opted for a `collections.OrderedDict` implementation.

We need to serialize our output from dict to bytes and can use the KafkaProducer `value_serializer` parameter to convert whilst passing our JSON objects.



##### Broker
I started the zookeeper server, which manages the kafka broker(s).
```shell
sudo bin/zookeeper-server-start.sh config/zookeeper.properties
```

I started the kafka broker server up
```shell
/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties
```

I created a new topic under the specified name of 'prices-topic', with simple settings
```shell
/home/kafka/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic prices-topic
```

I verified that the new topic was now available
```shell
/home/kafka/kafka/bin/kafka-topics.sh --list --zookeeper localhost:2181
```

##### Consumer
I wrote a bespoke consumer, that connects to the Kafka cluster via the nominated server location and ports. I made sure to decode the messages that had been encoded using 'utf-8'. The consumer outputs to the console as specified.

### Docker Compose
##### Folder layout
Starlizard
   + compose-pipeline
      + config
         + zookeeper.properties
         + server.properties
      + broker
         + broker_process.sh
      + producer
         + producer_process.sh
         + json_producer.py
      + consumer
         + consumer_process.sh
         + kafka_consumer.py
      docker-compose.yml
      Dockerfile
      requirements.txt
      single_process.sh
   + README.md

##### Prep
For ease of build, I moved my single_process.sh and broker_process.sh architecture into the Docker Compose YAML. This builds a single service with multiple process orchestration. This moves us from development into a container 'production' version fairly quickly so was satisfactory for this task.

I used the `spotify/kafka:latest` image as suggested and added pip3 to the installation to also accomodate the producer and consumer builds. 

##### Build
Server properties could be changed in the future, so to allow for this I have copied across my properties files into the build.

```shell
cp /home/kafka/kafka/config/zookeeper.properties config/zookeeper.properties
cp /home/kafka/kafka/config/server.properties config/server.properties
```

##### Use
Running `docker-compose up` (sudo dependent on your build) will be enough to orchestrate the build of the cloned repo and create the pipeline, printing JSON values to screen.

Subsequent builds unfortunately require `docker build --no-cache` as the Kafka server gets confused on reset in the current implementation.


### Future Work
Multiple services structure in Docker Compose rather than single service multiple process build
Separate images for different uses as the python3 installations take ages...
Multiple Kafka nodes
Failover / Recovery of cluster testing
Full cache flush forced
Code refactoring (dependent on amount of potential future use)

