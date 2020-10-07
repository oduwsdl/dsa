#!/bin/bash

export PATH=/usr/local/bin:$PATH

set -e
set -x

if [ -z $1 ]; then
    echo "You must specify a collection ID"
    exit 255
else
    collection_id=$1
fi

if [ -z $2 ]; then
    echo "You must specify a post date for this puddle"
    exit 255
else
    post_date=$2
fi

if [ -z $3 ]; then
    echo "You must specify a working directory"
    exit 255
else
    working_directory=$3
    mkdir -p ${working_directory}
fi

if [ -z $4 ]; then
    echo "user must specify a template file for DSA1 story"
    exit
else
    template_filename="$4"
fi

if [ -z $5 ]; then
    echo "You must specify an output filename"
    exit 255
else
    output_file=$5
fi

sg_month=`date '+%m'`
sg_date=`date '+%d'`
sg_year=`date '+%Y'`
sg_hour=`date '+%H'`
sg_minute=`date '+%m'`
sg_second=`date '+%S'`

post_date="${sg_year}-${sg_month}-${sg_date}"

mementos_file=${working_directory}/story-mementos.tsv
metadata_report=${working_directory}/metadata.json
entity_report=${working_directory}/entity_data.tsv
sumgram_report=${working_directory}/sumgram_data.tsv
image_report=${working_directory}/imagedata.json
story_data_file=${working_directory}/raintale-story.json
small_striking_image=assets/img/archiveit_striking_images/${post_date}-${collection_id}.png
errorfile=${working_directory}/memento_errors.tsv

cd ${working_directory}

local_template_filename=./`basename ${template_filename}`

if [ ! -e ${local_template_filename} ]; then
    echo "copying template filename ${template_filename} to ."
    cp ${template_filename} ${local_template_filename} # docker can't follow symlinks
fi

# 1. sample mementos from the collection
if [ ! -e ${mementos_file} ]; then
    echo "`date` --- executing command"
    docker-compose run hypercane hc sample dsa1 -i archiveit -a ${collection_id} \
        --working-directory ${working_directory} \
        -l ${working_directory}/${collection_id}-`date '+%Y%m%d%H%M%S'`.log \
        --memento-damage-url http://mementodamage:32768 \
        -o ${mementos_file} -e ${errorfile}

else

    echo "already discovered ${mementos_file} so moving on to next command..."

fi

# 2. Gather collection metadata
if [ ! -e ${metadata_report} ]; then
    echo "`date` --- executing command"
    docker-compose run hypercane hc report metadata -i archiveit -a ${collection_id} -o ${metadata_report} -l ${working_directory}/${collection_id}-report-metadata-`date '+%Y%m%d%H%M%S'`.log -e ${errorfile}
else
    echo "already discovered ${metadata_report} so moving on to next command..."
fi

# 3. Generate entity report
if [ ! -e ${entity_report} ]; then
    echo "`date` --- executing command"
    docker-compose run hypercane hc report entities -i mementos -a ${mementos_file} -o ${entity_report} -l ${working_directory}/${collection_id}-report-entities-`date '+%Y%m%d%H%M%S'`.log  -e ${errorfile}
else
    echo "already discovered ${entity_report} so moving on to next command..."
fi

# 4. Generate sumgram report
if [ ! -e ${sumgram_report} ]; then
    echo "`date` --- executing command"
    docker-compose run hypercane hc report terms -i mementos -a ${mementos_file} -o ${sumgram_report} --sumgrams -l ${working_directory}/${collection_id}-report-terms-`date '+%Y%m%d%H%M%S'`.log  -e ${errorfile}
else
    echo "already discovered ${sumgram_report} so moving on to next command..."
fi

# 5. Generate image report
if [ ! -e ${image_report} ]; then
    echo "`date` --- executing command"
    docker-compose run hypercane hc report image-data -i mementos -a ${mementos_file} -o ${image_report} -l ${working_directory}/${collection_id}-report-imagedata-`date '+%Y%m%d%H%M%S'`.log  -e ${errorfile}
else
    echo "already discovered ${image_report} so moving on to next command..."
fi

# 6. Consolidate reports and URI-M list to generate Raintale story data
if [ ! -e ${story_data_file} ]; then
    echo "`date` --- executing command:::"
    docker-compose run hypercane hc synthesize raintale-story -i mementos -a ${mementos_file} -o ${story_data_file} --imagedata ${image_report} --title "Archive-It Collection" --termdata ${sumgram_report} --entitydata ${entity_report} --collection_metadata ${metadata_report}  -e ${errorfile}
else
    echo "already discovered ${story_data_file} so moving on to next command..."
fi

# 7. Generate Jekyll HTML file for the story
if [ ! -e ${output_file} ]; then
    echo "`date` --- executing command:::"
    docker-compose run raintale tellstory -i ${story_data_file} --storyteller template --story-template ${local_template_filename} -o ${output_file} --generated-by "AlNoamany's Algorithm"
else
    echo "already created story at ${output_file}"
fi
