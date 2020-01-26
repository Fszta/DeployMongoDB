# MongoDB
## 1- Deploy MongoDB database with docker

This will automaticly pull the latest image of MongoDB from DockerHub

```
docker run --name mongodb \
  -p 27017:27017 \
  -v /path_to_folder/data/:/data/db \
  -d mongo:latest

```
Let's detail command options : 
* Name the container 
```
--name mongodb 
```
* Map the container port to host's one, by default mongodb use port 27017
```
 -p 27017:27017
```
* Create a volume to store data into host machine : 
```
 -v /path_to_folder/data/:/data/db 
```

You can create a bash file containing previous command to launch mongodb container:
First create launchMongoDB.sh & copy the docker run command inside
```
touch lauchMongoDB.sh
```
Make it executable :
```
chmod +x launchMongoDB.sh
```
Run mongodb container : 
```
./launchMongoDB.sh
```
## 2- Deploy MongoDB with docker-compose 
A good practice when deploying multiple containers is to use docker-compose. It allows you to deploy multiple containers at same time. Applications services need to be configure in docker-comple.yaml file. To illustrate docker-compose's interest we'll later deploy a GUI to manage MongoDB : Mongo Express. First of all let's define the docker-compose file used to deploy mongodb

Assuming you already have docker installed, you just need to install docker-compose by downloading the last stable version & make binary executable

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
```
sudo chmod +x /usr/local/bin/docker-compose
```

Let's write a basic docker-compose file which does exactly the same thing as the command describe in part 1 
```
version: '3'
services:
  mongo:
    image: mongo:latest
    container_name: 'mongodb'
    ports:
      - "27017:27017"
    volumes:
      - ./data:/data/db
```

You can now running mongodb container using the following : 

```
docker-compose up -d
```
Our mongodb container is now running and is accessible on port 27017.
As for previous command, -d option is used to run container in background.


## 3- Deploy Mongo Express 
Mongo express is a web based admin interface

![GitHub Logo](/screens/MongoExpress.png)

Let's add Mongo Express configuration to our docker-compose.yaml file.

```
version: '3'

services:
  mongo:
    image: mongo:latest
    container_name: 'mongodb'
    ports:
      - "27017:27017"
    volumes:
      - ./data:/data/db
    networks:
      - mongo-network

  mongo-express:
    image: mongo-express:latest
    container_name: 'mongoexpress'
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=root
      - ME_CONFIG_MONGODB_ADMINPASSWORD=password
      - ME_CONFIG_BASICAUTH_USERNAME=admin
      - ME_CONFIG_BASICAUTH_PASSWORD=password
    links:
      - mongo
    networks:
      - mongo-network
    depends_on:
      - mongo

networks:
  mongo-network:
    driver: bridge
```

To deploy our containers, run the same command as previously. 
We can check that both are running using :
```
docker-compose ps 
```
You should have the following output

![GitHub Logo](/screens/compose_ps.png)

Mongo express interface is now accessible at http://127.0.0.1:8081
