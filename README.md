# Starlizard
A temporary repository for interview purposes only. This repo walks through the steps taken to build a pipeline that comprises of a producer, a kafka broker and a consumer. The spec explicitly asks for Docker Compose as the method of orchestration, alongside Python 3+ and Docker Compose 1.17+.

This README is made up of the following sections:
1. Setup
   
   a. Installs

2. Feedback


---
### Setup
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
. virtualenvs/pipeline-producer/bin/activate
```
I then use the infamous and lazy trick of saving the developed environment down into the requirements.txt file once happy, using `pip3 freeze > requirements.txt`.

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
