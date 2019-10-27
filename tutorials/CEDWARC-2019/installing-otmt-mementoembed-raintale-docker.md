# Installing the Off-Topic Memento Toolkit (OTMT), MementoEmbed, and Raintale with Docker

Docker is the intended platform from which these services are run.

## the Off-Topic Memento Toolkit (OTMT)

### Installing and Running:

1. Create a new folder named otmt-working
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/off-topic-memento-toolkit/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1
5. Type the following command:
```
docker-compose run otmt bash
```
6. Run all OTMT commands (e.g. `detect_off_topic`, `exclude_duplicates`) from that prompt

### Shutting down the OTMT:
1. In the terminal, type
```
exit
```
  * **Note: Run the following commands from the same directory or this will not work**

2. Shut down the Docker containers
```
docker-compose stop
```

3. Remove the Docker containers
```
docker-compose rm -f
```

## MementoEmbed

### Installing and Running MementoEmbed StandAlone

1. Open a terminal
2. Tell docker to fetch the MementoEmbed image
```
docker pull oduwsdl/mementoembed
```
3. Run MementoEmbed
```
docker run -d --name mementoembed -p 5550:5550 oduwsdl/mementoembed
```
4. MementoEmbed is now available at http://localhost:5550

### Stopping and Removing MementoEmbed

1. Run the following command
```
docker stop mementoembed
```
2. To remove the container, type:
```
docker rm mementoembed
```

## Raintale

Raintale requires MementoEmbed. If you have already followed the previous section's directions for starting MementoEmbed, stop if before executing these instructions.

### Installing and Running Raintale

1. Create a folder named raintale-working
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/raintale/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1
5. Type the following command:
```
docker-compose run raintale bash
```
6. Run all Raintale commands (e.g. `tellstory`) from that prompt

### Shutting down Raintale:
1. In the terminal, type
```
exit
```
  * **Note: Run the following commands from the same directory or this will not work**

2. Shut down the Docker containers
```
docker-compose stop
```

3. Remove the Docker containers
```
docker-compose rm -f
```
