#!/bin/bash

for p in `docker ps -a | grep "mongo\|hypercane\|mementoembed\|raintale\|sgtk" | awk '{ print $1 }' | grep -v CONTAINER`; do 
    docker stop $p
    docker rm $p
done

docker network prune
