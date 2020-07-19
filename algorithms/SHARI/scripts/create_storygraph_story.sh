#!/bin/bash

export PATH=/usr/local/bin:$PATH

set -e
set -x

if [ -z $1 ]; then
    # sg_month=`date '+%m'`
    # sg_date=`date '+%d'`
    # sg_year=`date '+%Y'`
    # sg_hour=`date '+%H'`
    # sg_minute=`date '+%m'`
    # sg_second=`date '+%S'`
    echo "user must specify a date in YYYY-MM-DD format"
    exit
else
    sg_date=`echo $1 | awk -F- '{ print $3 }'`
    sg_month=`echo $1 | awk -F- '{ print $2 }'`
    sg_year=`echo $1 | awk -F- '{ print $1 }'`
    sg_hour=`date '+%H'`
    sg_minute=`date '+%m'`
    sg_second=`date '+%S'`
fi

post_date="${sg_year}-${sg_month}-${sg_date}"

if [ -z $2 ]; then
    # working_directory=`mktemp -d -t storygraph-stories-`
    echo "user must specify a working directory"
    exit
else
    working_directory="$2/${post_date}"
    mkdir -p ${working_directory}
fi

if [ -z $3 ]; then
    echo "user must specify a template file for SHARI story"
    exit
else
    template_filename="$3"
fi

if [ -z $4 ]; then
    echo "user must specify an output file"
    exit
else
    output_file=$4
fi

if [ -z $5 ]; then
    mementoembed_endpoint="http://localhost:5550"
else
    mementoembed_endpoint=$5
fi

echo "`date` --- using working directory ${working_directory}"
echo "`date` --- using year: ${sg_year} ; month: ${sg_month}; date: ${sg_date}"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

original_resource_file=${working_directory}/story-original-resources.tsv
mementos_file=${working_directory}/story-mementos.tsv
entity_report=${working_directory}/entity_data.tsv
sumgram_report=${working_directory}/sumgram_data.tsv
image_report=${working_directory}/imagedata.json
sorted_mementos_file=${working_directory}/sorted-story-mementos.tsv
story_data_file=${working_directory}/raintale-story.json
# small_striking_image=assets/img/storygraph_striking_images/${post_date}.png
stopword_file="${script_dir}/../stopwords.txt"

# 1. query StoryGraph service for rank r story of the day
if [ ! -e ${original_resource_file} ]; then

    sg_file="${working_directory}/sgtk-maxgraph-${sg_year}${sg_month}${sg_date}.json"

    echo "creating StoryGraph file ${sg_file}"

    sgtk -o ${working_directory}/graphs_links.txt maxgraph \
        --daily-maxgraph-count=0 -y ${sg_year} --start-mm-dd=${sg_month}-${sg_date} --end-mm-dd=${sg_month}-${sg_date} \
        --cluster-stories --format=maxstory_links --maxstory-count=1 > ${working_directory}/sg-output.txt 2>&1
    sg_base_uri=`cat ${working_directory}/sg-output.txt | grep "service uri:" | awk '{ print $3 }'`
    sg_fragment=`cat ${working_directory}/sg-output.txt | grep "maxgraph cursor:" | awk '{ print $3 }'`
    echo "${sg_base_uri}${sg_fragment}" > ${working_directory}/sg.url.txt

    echo "URI-R" > ${original_resource_file}
    cat ${working_directory}/graphs_links.txt >> ${original_resource_file}
else
    echo "already discovered ${original_resource_file} so moving on to next command..."
fi

# 2. Create URI-Ms from URI-Rs
if [ ! -e ${mementos_file} ]; then
    hc identify mementos -i original-resources -a ${original_resource_file} -cs mongodb://localhost/csStoryGraph -o ${mementos_file}
else
    echo "already discovered ${mementos_file} so moving on to next command..."
fi

# 3. Generate entity report
if [ ! -e ${entity_report} ]; then
    echo "`date` --- executing command"
    hc report entities -i mementos -a ${mementos_file} -cs mongodb://localhost/csStoryGraph -o ${entity_report}
else
    echo "already discovered ${entity_report} so moving on to next command..."
fi

# 4. Generate sumgram report
if [ ! -e ${sumgram_report} ]; then
    echo "`date` --- executing command"
    hc report terms -i mementos -a ${mementos_file} -cs mongodb://localhost/csStoryGraph -o ${sumgram_report} --sumgrams --added-stopwords ${stopword_file}
else
    echo "already discovered ${sumgram_report} so moving on to next command..."
fi

# 5. Generate image report
if [ ! -e ${image_report} ]; then
    echo "`date` --- executing command"
    hc report image-data -i mementos -a ${mementos_file} -cs mongodb://localhost/csStoryGraph -o ${image_report}
else
    echo "already discovered ${image_report} so moving on to next command..."
fi

# 6. Order URI-Ms by publication date
if [ ! -e ${sorted_mementos_file} ]; then
    echo "`date` --- executing command:::"
    hc order pubdate-else-memento-datetime -i mementos -a ${mementos_file} -o ${sorted_mementos_file} -cs mongodb://localhost/csStoryGraph
else
    echo "already discovered ${working_directory}/sorted-story-mementos.tsv so moving on to next command..."
fi

# 7. Consolidate reports and URI-M list to generate Raintale story data
if [ ! -e ${story_data_file} ]; then
    echo "`date` --- executing command:::"
    hc synthesize raintale-story -i mementos -a ${mementos_file} -o ${story_data_file} -cs mongodb://localhost/csStoryGraph --imagedata ${image_report} --title "StoryGraph Biggest Story ${post_date}" --termdata ${sumgram_report} --entitydata ${entity_report}
else
    echo "already discovered ${story_data_file} so moving on to next command..."
fi

# 8. Generate Jekyll HTML file for the day's rank r story
if [ ! -e ${output_file} ]; then
    echo "`date` --- executing command:::"
    sg_url=`cat ${working_directory}/sg.url.txt`
    tellstory -i ${story_data_file} --storyteller template --story-template ${template_filename} -o ${output_file} --collection-url ${sg_url} --generation-date ${post_date}T${sg_hour}:${sg_minute}:${sg_second} --mementoembed_api ${mementoembed_endpoint}
else
    echo "already created story at ${output_file}"
fi
