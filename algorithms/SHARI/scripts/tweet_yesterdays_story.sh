#!/bin/bash

# echo "starting script"

WORKING_DIRECTORY=$1
#DATE_YESTERDAY=`date --date "yesterday" '+%Y-%m-%d'`
DATE_YESTERDAY=$2
CREDENTIALS_FILE=$3

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

post_date=${DATE_YESTERDAY}

working_dir="${WORKING_DIRECTORY}/${post_date}"

# echo "using post date ${post_date}"

#human_readable_date=`date --date "${post_date}" '+%A, %B %e, %Y'`
human_readable_date=`date --date "${post_date}" '+%A, %B %e, %Y'`
#directory_date=`date --date "${post_date}" '+%Y/%m/%d'`
directory_date=`date --date "${post_date}" '+%Y/%m/%d'`

sumgrams=`cat ${working_dir}/sumgram_data.tsv | awk -F'\t' '{ print $1 " (" $2 ")" }' | head -n 6 | tail -n 5 | tr '\n' ',' | sed 's/,$//g' | sed 's/,/, /g'`

echo "sumgrams are ${sumgrams}"

post_url="https://oduwsdl.github.io/dsa-puddles/stories/shari/${directory_date}/storygraph_biggest_story_${post_date}/"
post_message="From the SHARI process: @storygraphbot's biggest news story for ${human_readable_date} -- ${sumgrams}"

echo "using post message: ${post_message}"

# these may need to be changed depending on environment
#export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
#source /usr/local/bin/virtualenvwrapper.sh
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
workon shari

echo 

python ${script_dir}/tweet_if_post_present.py "${CREDENTIALS_FILE}" "${post_url}" "${post_message}"

# > /Users/smj/Unsynced-Projects/dsa-puddles-logs/tweeting-storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

echo "done running script"
