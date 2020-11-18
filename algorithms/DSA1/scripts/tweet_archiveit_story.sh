#!/bin/bash

# echo "starting script"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

post_date=$1
collection_id=$2
working_dir=$3
credentials_file=$4

# working_dir="/Volumes/nerfherder-external/Unsynced-Projects/shari-working/${post_date}"

# echo "using post date ${post_date}"

human_readable_date=`/usr/local/bin/gdate --date "${post_date}" '+%A, %B %e, %Y'`
directory_date=`/usr/local/bin/gdate --date "${post_date}" '+%Y/%m/%d'`

sumgrams=`cat ${working_dir}/sumgram_data.tsv | awk -F'\t' '{ print $1 " (" $2 ")" }' | head -n 6 | tail -n 5 | tr '\n' ',' | sed 's/,$//g' | sed 's/,/, /g'`
title=`cat ${working_dir}/metadata.json | grep '^[ ]*"name":' | sed 's/.*"name": "\([^"]*\)".*$/\1/g'`

echo "sumgrams are ${sumgrams}"

post_url="https://oduwsdl.github.io/dsa-puddles/stories/archiveit_collections/${directory_date}/archive-it_collection_${collection_id}/"
post_message="From the DSA1 Algorithm: a story summarizing Archive-It collection ${collection_id}: ${title} -- ${sumgrams}"

echo "using post message: ${post_message}"

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
workon shari

echo "Tweet message:"
echo ${post_message}

echo "Tweet URL:"
echo ${post_url}

python ${script_dir}/tweet_if_post_present.py ~/Unsynced-Projects/dsa-credentials/twitter-credentials.yaml "${post_url}" "${post_message}"

# > /Users/smj/Unsynced-Projects/dsa-puddles-logs/tweeting-storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

echo "done running script"
