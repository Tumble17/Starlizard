# =============================================
#               PACKAGES
# =============================================
import argparse
import kafka
import json

# =============================================
#               PARSER
# =============================================
parser = argparse.ArgumentParser(
    description='Consumes topic messages from a Kafka cluster'
)
parser.add_argument('--topic_name', required=False, help='Name of the kafka topic to consume from')
parser.add_argument('--server_locations_list', required=False, help='Location of Kafka broker nodes')
parser.add_argument('--from_start', required=False, help='Whether to consume from history (True / False)')
parser_args = parser.parse_args()

# =============================================
#              GLOBAL FIELDS
# =============================================
TEST_MODE = False
KAFKA_TOPIC_NAME = 'prices-topic'
KAFKA_BROKER_LOCATIONS = ['localhost:9092']
KAFKA_FROM_START = False

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
    global KAFKA_TOPIC_NAME, KAFKA_BROKER_LOCATION, KAFKA_FROM_START
    
    # Kafka topic reference name
    if not passed_args.topic_name == None:
        print("Overwriting global kafka topic name from " + KAFKA_TOPIC_NAME + " to " + passed_args.topic_name)
        KAFKA_TOPIC_NAME = passed_args.topic_name

    # Kafka broker nodes location list
    if not passed_args.server_locations_list == None:
        print("Overwriting global kafka node locations list from " + KAFKA_BROKER_LOCATIONS + " to " + passed_args.server_locations_list)
        KAFKA_BROKER_LOCATIONS = passed_args.server_locations_list

    # Kafka broker nodes location list
    if not passed_args.from_start == None:
        print("Overwriting global listener history toggle from " + KAFKA_FROM_START + " to " + passed_args.from_start)
        KAFKA_FROM_START = passed_args.from_start

def consume_topic(kafka_topic, server_locations_list, from_start):
    """
    |
    | Consume messages from a Kafka topic
    |
    | Parameters
    | ----------
    | kafka_topic : str - Name of the existing Kafka topic to consume
    | server_locations_list : list - List of the kafka brokers to point to and consume from
    | from_start : str - Whether to pull from history or now (latest / earliest)
    |
    | Returns
    | -------
    |
    |
    | Notes
    | -----
    |
    """
    # Parse the from_start parameter
    from_start_parsed = from_start
    if not from_start == 'earliest':
        from_start_parsed = 'latest'

    # Set up consumer connection
    consumer = kafka.KafkaConsumer(kafka_topic,
            bootstrap_servers=server_locations_list,
            auto_offset_reset=from_start_parsed)
    print("Set up connection to " + kafka_topic + " topic at " + str(server_locations_list))

    while not TEST_MODE:

        # Print out consumer messages from Kafka broker on topic
        for message in consumer:
            print(message.value.decode('utf-8'))

def process():
    # Overwrite globals with command arguments where passed
    collect_optional_command_arguments(passed_args=parser_args)

    # Connecto Kafka broker and listen to the topic passed by name
    consume_topic(kafka_topic=KAFKA_TOPIC_NAME, server_locations_list=KAFKA_BROKER_LOCATIONS, from_start=KAFKA_FROM_START)

process()
