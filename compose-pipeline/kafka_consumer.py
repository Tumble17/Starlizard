import kafka

def consume():

    consumer = kafka.KafkaConsumer('prices-topic', auto_offset_reset='earliest')
    for message in consumer:
        print(message)
