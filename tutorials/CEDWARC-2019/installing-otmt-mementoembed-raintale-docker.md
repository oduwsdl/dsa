# Installing the Off-Topic Memento Toolkit (OTMT), MementoEmbed, and Raintale with Docker

Docker is the intended platform from which these services are run.

## Installing and Running the Off-Topic Memento Toolkit (OTMT):

1. Create a new folder named otmt-working
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/off-topic-memento-toolkit/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1
5. Type the following command:
```
docker-compose run otmt bash
```
6. Run all OTMT commands (e.g. `detect_off_topic`, `exclude_duplicates`) from that prompt

## Shutting down the OTMT:
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

## Installing and Running Raintale

1. Create a folder named raintale-working
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/raintale/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1

(to be completed...)
