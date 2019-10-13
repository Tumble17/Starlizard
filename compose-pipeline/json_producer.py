import kafka
import json
import random
from collections import OrderedDict

producer = kafka.KafkaProducer(bootstrap_servers=['localhost:9092'], 
                               value_serializer=lambda x: x.encode('utf-8'))

WHILE_LOOP_INDEX = 0
GLOBAL_SEED  = 42
SEEDING_FLAG = False
TEST_MODE = False

while WHILE_LOOP_INDEX < 1000:
    
    if SEEDING_FLAG:
        
        random.seed(GLOBAL_SEED); random_three_digit_match = random.randint(100, 999)
        random.seed(GLOBAL_SEED); random_price = round(random.uniform(1.0, 10.0), 2)

    else:
        random_three_digit_match = random.randint(100, 999)
        random_price = round(random.uniform(1.0, 10.0), 2)

    json_message = json.dumps(OrderedDict([("match", random_three_digit_match), ("price", random_price)]))
    
    # Attempt to send message to the Kafka topic
    producer.send('prices-topic', json_message)

    if TEST_MODE:
        WHILE_LOOP_INDEX += 1
        print(json_message)

