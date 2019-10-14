import kafka
import json

TEST_MODE = False

def consume():

    consumer = kafka.KafkaConsumer('prices-topic', 
            bootstrap_servers=['localhost:9092'])
            #auto_offset_reset='earliest')

    while not TEST_MODE:
        
        # Print out consumer messages from Kafka broker on topic
        for message in consumer:
            print(message.value.decode('utf-8'))

consume()
