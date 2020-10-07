#!/bin/bash

export PATH=/usr/local/bin:$PATH

if [ -z $1 ]; then
    echo "date is missing, first argument must be a date in YYYY-MM-DD format"
else
    post_date=$1
fi

if [ -z $2 ]; then
    echo "Archive-It collection ID is missing"
else
    collection_id=$2
fi

if [ -z $3 ]; then
    echo "working directory is missing, second argument must be a working directory"
else
    working_directory=$3
    working_directory=${working_directory}/${collection_id}/${post_date}
fi

if [ -z $4 ]; then
    echo "puddles directory is missing, third argument must be where you cloned the DSA Puddles repository"
else
    dsa_puddles_directory=$4
fi

jekyll_story_file="${dsa_puddles_directory}/_posts/${post_date}-archiveit-collection-${collection_id}.html"
small_striking_image="${dsa_puddles_directory}/assets/img/archiveit_striking_images/${post_date}-${collection_id}.png"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -d ${working_directory} ]; then
    mkdir -p ${working_directory}
fi

if [ -n ${4+x} ]; then
    if [ "$4" == "--purge" ]; then
        rm -rf ${working_directory}
        rm ${jekyll_story_file}
        rm ${small_striking_image}
        mkdir -p ${working_directory}
    fi
fi

cd ${working_directory}

if [ ! -e ./docker-compose.yml ]; then
    ln -s ${script_dir}/../docker-compose.yml .
fi

# if [ ! -e ./stopwords.txt ]; then
#     cp ${script_dir}/../stopwords.txt . # docker can't follow symlinks
# fi

if [ ! -e ./create_archiveit_story_docker.sh ]; then
    ln -s ${script_dir}/create_archiveit_story_docker.sh .    
fi

echo "beginning execution of basic story creation"

./create_archiveit_story_docker.sh ${collection_id} ${post_date} . ${script_dir}/../templates/archiveit-collection-story.html story-output.html > dsa1-process-`date '+%Y%m%d%H%M%S'`.log 2>&1

echo "done executing basic story creation"

if [ ! -e story-output.html ]; then
    echo "Failed to produce story output, exiting..."
    exit 255
fi

echo "copying `pwd`/story-output.html to ${jekyll_story_file}"
cp story-output.html ${jekyll_story_file}

# swap the striking image with a smaller thumbnail so that the main page will load faster
if [ ! -e ${small_striking_image} ]; then
    striking_image_url=`grep "^img:" ${jekyll_story_file} | awk '{ print $2 }'`

    echo "striking image URL is ${striking_image_url}"
    echo "looking for ${working_directory}/${post_date}-striking-image.dat"

    if [ ! -e ${working_directory}/${post_date}-striking-image.dat ]; then

        if [ -n ${striking_image_url} ]; then
            wget -O ${working_directory}/${post_date}-striking-image.dat ${striking_image_url}
            # TODO: download again if size is 0
        fi

    else
        echo "already downloaded image from ${striking_image_url}"
    fi

    echo "looking for ${working_directory}/${post_date}-striking-image-origsize.png"

    if [ ! -e ${working_directory}/${post_date}-striking-image-origsize.png ]; then
        convert ${working_directory}/${post_date}-striking-image.dat ${working_directory}/${post_date}-striking-image-origsize.png
    else
        echo "already converted image to PNG"
    fi

    if [ ! -e ${small_striking_image} ]; then
        convert ${working_directory}/${post_date}-striking-image-origsize.png -resize 368.391x245.531 ${small_striking_image}
    else
        echo "already resized image"
    fi

else
    echo "already generated smaller striking image for ${small_striking_image}"
fi

sed -i '' -e "s|^img: .*$|img: /dsa-puddles/assets/img/archiveit_striking_images/${post_date}-${collection_id}.png|g" ${jekyll_story_file}

# cd ${dsa_puddles_directory}
# git pull
# git add ${jekyll_story_file}
# git add ${small_striking_image}
# git commit -m "adding archiveit story for ${post_date}"
# git push
