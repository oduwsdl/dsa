#!/bin/bash

export PATH=/usr/local/bin:$PATH

stop_mementoembed () {
    docker stop mementoembed
    docker rm mementoembed
}

restart_mementoembed () {
    stop_mementoembed
    docker run -d --name mementoembed -p 5550:5550 oduwsdl/mementoembed:latest
    sleep 20
}

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh

post_date=$1
working_directory=$2
dsa_puddles_directory=$3

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

jekyll_story_file="${dsa_puddles_directory}/_posts/${post_date}-storygraph-bigstory.html"
small_striking_image="${dsa_puddles_directory}/assets/img/storygraph_striking_images/${post_date}.png"

if [ -n ${3+x} ]; then
    if [ "$3" == "--purge" ]; then
        rm -rf ${working_directory}
        rm ${jekyll_story_file}
        rm ${small_striking_image}
        mkdir -p ${working_directory}
    fi
fi

restart_mementoembed

workon storygraph-stories

# first run
${script_dir}/create_storygraph_story.sh ${post_date} ${working_directory} ${script_dir}/../templates/storygraph-story.html ${jekyll_story_file} > /Users/smj/Unsynced-Projects/dsa-puddles-logs/storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

# # # second run to potentially encourage the Internet Archive to archive some images
# sleep 1800
# rm ${jekyll_story_file}
# restart_mementoembed
# ${script_dir}/create_storygraph_story.sh ${post_date} ${working_directory} > /Users/smj/Unsynced-Projects/dsa-puddles-logs/storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

# # # third run to potentially encourage the Internet Archive to archive some images
# sleep 1800
# rm ${jekyll_story_file}
# restart_mementoembed
# ${script_dir}/create_storygraph_story.sh ${post_date} ${working_directory} > /Users/smj/Unsynced-Projects/dsa-puddles-logs/storygraph-biggest-`date '+%Y%m%d%H%M%S'`.log 2>&1

stop_mementoembed

# swap the striking image with a smaller thumbnail so that the main page will load faster
if [ ! -e ${small_striking_image} ]; then
    striking_image_url=`grep "^img:" ${jekyll_story_file} | awk '{ print $2 }'`

    if [ ! -e ${working_directory}/${post_date}-striking-image.dat ]; then
        wget -O ${working_directory}/${post_date}-striking-image.dat ${striking_image_url}
        # TODO: download again if size is 0
    else
        echo "already downloaded image from ${striking_image_url}"
    fi

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

# extra - fix the image every time in case we are rerun
sed -i '' -e "s|^img: .*$|img: /dsa-puddles/${small_striking_image}|g" ${jekyll_story_file}

cd ${dsa_puddles_directory}
git pull
git add ${jekyll_story_file}
git add ${small_striking_image}
git commit -m "adding storygraph story for ${post_date}"
git push
