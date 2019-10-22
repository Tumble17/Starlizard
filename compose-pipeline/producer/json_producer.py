# =============================================
#               PACKAGES
# =============================================
import argparse
import kafka
import json
import random
from collections import OrderedDict

# =============================================
#               PARSER
# =============================================
parser = argparse.ArgumentParser(
    description='Produces messages to send to a Kafka cluster'
)
parser.add_argument('--topic_name', required=False, help='Name of the kafka topic to consume from')
parser.add_argument('--server_locations_list', required=False, help='Location of Kafka broker nodes')
parser_args = parser.parse_args()

# =============================================
#              GLOBAL FIELDS
# =============================================
WHILE_LOOP_INDEX = 0
GLOBAL_SEED  = 42
SEEDING_FLAG = False
TEST_MODE = False
KAFKA_TOPIC_NAME = 'prices-topic'
KAFKA_BROKER_LOCATIONS = ['broker:9092']

# =============================================
#               FUNCTIONS
# =============================================
def collect_optional_command_arguments(passed_args):
    """
    |
    | Overwrites global variables when command line arguments are passed
    |
    | Parameters
    | ----------
    | passed_args : argspace.Namespace - Command line arguments
    |
    | Returns
    | -------
    |
    |
    | Notes
    | -----
    |
    """
    # Reference globals
    global KAFKA_TOPIC_NAME, KAFKA_BROKER_LOCATION

    # Kafka topic reference name
    if not passed_args.topic_name == None:
        print("Overwriting global kafka topic name from " + KAFKA_TOPIC_NAME + " to " + passed_args.topic_name)
        KAFKA_TOPIC_NAME = passed_args.topic_name

    # Kafka broker nodes location list
    if not passed_args.server_locations_list == None:
        print("Overwriting global kafka node locations list from " + KAFKA_BROKER_LOCATIONS + " to " + passed_args.server_locations_list)
        KAFKA_BROKER_LOCATIONS = passed_args.server_locations_list



def connect_kafka_producer(server_locations_list):
    """
    |
    | Connect to a provisioned Kafka broker
    |
    | Parameters
    | ----------
    | server_locations_list : list - A list of broker node locations to connect the producer to
    |
    | Returns
    | -------
    | producer : kafka.producer.KafkaProducer - A Kafka client that publishes records to the Kafka broker cluster
    |
    | Notes
    | -----
    |
    """
    # Create a connection between broker and producer / publisher
    producer = kafka.KafkaProducer(bootstrap_servers=server_locations_list,
                                    value_serializer=lambda x: x.encode('utf-8'))

    return producer

def produce_json_randomised_values(kafka_topic, test_loop_count=1000):
    """
    |
    | Generate the randomised outputs of the specific JSON object schema
    |
    | Parameters
    | ----------
    | test_loop_count : int - Number of iterations to generate for, in test mode
    |
    | Returns
    | -------
    | producer : kafka.producer.KafkaProducer - A Kafka client that publishes records to the Kafka broker cluster
    |
    | Notes
    | -----
    |
    """
    # Reference globals
    global KAFKA_BROKER_LOCATIONS, WHILE_LOOP_INDEX, GLOBAL_SEED, TEST_MODE

    # Connect to broker(s)
    producer = connect_kafka_producer(server_locations_list=KAFKA_BROKER_LOCATIONS)

    # Loop
    while WHILE_LOOP_INDEX < test_loop_count:

        if SEEDING_FLAG:
            random.seed(GLOBAL_SEED); random_three_digit_match = random.randint(100, 999)
            random.seed(GLOBAL_SEED); random_price = round(random.uniform(1.0, 10.0), 2)

        else:
            # Create a random three digit number for the 'match' key's value
            random_three_digit_match = random.randint(100, 999)
            # Create a random number between 1 and 10, rounded to 2dp, for the 'price' key's value
            random_price = round(random.uniform(1.0, 10.0), 2)

        # Create the JSON object
        json_message = json.dumps(OrderedDict([("match", random_three_digit_match), ("price", random_price)]))

        # Attempt to send message to the Kafka topic
        producer.send(kafka_topic, json_message)

        if TEST_MODE:
            # Moves the counter on, to move loop to completion
            WHILE_LOOP_INDEX += 1
            print(json_message)

# =============================================
#               PROCESS
# =============================================
def process():

    # Overwrite globals with command arguments where passed
    collect_optional_command_arguments(passed_args=parser_args)

    # Connect to the Kafka broker(s)
    connect_kafka_producer(server_locations_list=KAFKA_BROKER_LOCATIONS)

    # Generate JSON outputs and publish to Kafka cluster
    produce_json_randomised_values(kafka_topic=KAFKA_TOPIC_NAME)

process()
