# Starlizard
Temporary repo for Starlizard interview process

### Setup
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
I installed pip3 so that I could install virtual environments for development of the separate pipeline components, before passing them to the services within the Docker Compose. https://askubuntu.com/questions/778052/installing-pip3-for-python3-on-ubuntu-16-04-lts-using-a-proxy
    
```shell
sudo apt-get update   
sudo apt-get -y install python3-pip
```

