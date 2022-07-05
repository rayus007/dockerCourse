#!/bin/bash

# The following command is to create a Docker Network as Bridge mode
docker network create -d bridge myBridgeNetwork

# The following command is to create specific docker volume for postgres container
docker volume create --name myPostgres_volume

# The following command is to create/start the postgres container, setting up environmental variables to use them later in sonarqube container
# Detached mode
# Also it is attached to Docker Bridge Network created at the beginning
docker run -d --name myPostgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_USER=myUser \
    -e POSTGRES_DB=myDB \
    -v myPostgres_volume:/var/lib/postgresql/data \
    --network myBridgeNetwork \
    postgres

# The following commands are to create sonarqube volumes needed for sonarQube container.
docker volume create --name sonarqube_data
docker volume create --name sonarqube_extensions
docker volume create --name sonarqube_logs

# The following command is to create/start the sonarQube container
# Detached mode
# Used postgres environmental variables previously set up for Postgres container.
# Also it is attached to Docker Bridge Network created at the beginning
docker run -d --name mySonarqube \
    -p 9000:9000 \
    -e SONAR_JDBC_URL=jdbc:postgresql://myPostgres/myDB \
    -e SONAR_JDBC_USERNAME=myUser \
    -e SONAR_JDBC_PASSWORD=postgres \
    -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
    -v sonarqube_data:/opt/sonarqube/data \
    -v sonarqube_extensions:/opt/sonarqube/extensions \
    -v sonarqube_logs:/opt/sonarqube/logs \
    --network myBridgeNetwork \
    sonarqube

# The following command is to create/start the Jenkins container
# Detached mode, ports specified, and volumes specified
# Also it is attached to Docker Bridge Network created at the beginning
docker run -d --name myJenkins \
    -p 8080:8080 \
    -p 50000:50000 \
    -v jenkins-docker-certs:/certs/client \
    -v jenkins-data:/var/jenkins_home \
    --restart=on-failure \
    --network myBridgeNetwork \
    jenkins/jenkins:lts-jdk11

# The following command is to create/start the Nexus3 container
# Detached mode, ports and volumes specified
# Also it is attached to Docker Bridge Network created at the beginning
docker run -d --name myNexus \
    -p 8081:8081 \
    -v nexus-data:/nexus-data \
    --network myBridgeNetwork \
    sonatype/nexus3

# The following command is to create/start the Portainer container
# Detached mode, ports and volumes specified
# Also it is attached to Docker Bridge Network created at the beginning
docker run -d --name myPortainer \
    -p 8000:8000 -p 9443:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart=always \
    --network myBridgeNetwork \
    portainer/portainer-ce:2.9.3

# The following command is to verify that containers were created and are UP.
docker container ps

# The following command is to verify that containers are attached in bridge Network created at the beginning.
docker network inspect myBridgeNetwork
