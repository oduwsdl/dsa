#!/bin/bash

# echo "starting script"

DATE_YESTERDAY=`/usr/local/bin/gdate --date "yesterday" '+%Y-%m-%d'`

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

post_date=${DATE_YESTERDAY}

working_dir="/Volumes/nerfherder-external/Unsynced-Projects/shari-working/${post_date}"

# echo "using post date ${post_date}"

human_readable_date=`/usr/local/bin/gdate --date "${post_date}" '+%A, %B %e, %Y'`
directory_date=`/usr/local/bin/gdate --date "${post_date}" '+%Y/%m/%d'`

sumgrams=`cat ${working_dir}/sumgram_data.tsv | awk -F'\t' '{ print $1 " (" $2 ")" }' | head -n 6 | tail -n 5 | tr '\n' ',' | sed 's/,$//g' | sed 's/,/, /g'`

echo "sumgrams are ${sumgrams}"

post_url="https://oduwsdl.github.io/dsa-puddles/stories/shari/${directory_date}/storygraph_biggest_story_${post_date}/"
post_message="From the SHARI process: @storygraphbot's biggest news story for yesterday, ${human_readable_date} -- ${sumgrams}"

echo "using post message: ${post_message}"

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
workon shari

echo 

python ${script_dir}/tweet_if_post_present.py ~/Unsynced-Projects/dsa-credentials/twitter-credentials.yaml "${post_url}" "${post_message}"

# > /Users/smj/Unsynced-Projects/dsa-puddles-logs/tweeting-storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

echo "done running script"
