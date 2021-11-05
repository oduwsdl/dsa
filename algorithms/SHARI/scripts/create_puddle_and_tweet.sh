#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export PATH=/usr/local/bin:$PATH

PUDDLES_DIR="/Users/smj/SHARI/dsa-puddles"
PUDDLES_WORKING_DIR="/Users/smj/SHARI/dsa-puddles-working/storygraph-biggest-stories"
TWITTER_CREDENTIALS_FILE="/Users/smj/SHARI/credentials/twitter-credentials.yaml"

if [ -n "$1" ]; then
    YESTERDAY=$1
else
    YESTERDAY=`/usr/local/bin/gdate -d 'yesterday' '+%Y-%m-%d'`
fi

echo "creating SHARI puddle for $YESTERDAY"

# create story
echo "creating story"
${SCRIPT_DIR}/create_shari_puddle_for_date.sh ${YESTERDAY} ${PUDDLES_WORKING_DIR} ${PUDDLES_DIR}
status=$?

if [ ${status} -ne 0 ]; then
    echo "FAILURE: did not produce story"
    exit 22
fi

# wait for GH Pages to generate the story
echo "sleeping so that GitHub Pages can generate the new story"
sleep 300

# tell Twitter about it
echo "telling Twitter about the new story"
${SCRIPT_DIR}/tweet_yesterdays_story.sh ${PUDDLES_WORKING_DIR} ${YESTERDAY} ${TWITTER_CREDENTIALS_FILE}

# clean up after Docker
for p in `docker ps -a | grep "${YESTERDAY}_" | awk '{ print $1 }'`; do
    echo "stopping container $p";
    docker stop $p;
    echo "removing container $p";
    docker rm $p;
done

for p in `docker ps -a | grep "${YESTERDAY}-" | awk '{ print $1 }'`; do
    echo "stopping container $p";
    docker stop $p;
    echo "removing container $p";
    docker rm $p;
done

docker system prune --volumes -f
