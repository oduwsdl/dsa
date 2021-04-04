# Installing Hypercane, MementoEmbed, and Raintale with Docker

Docker is the intended platform for which we intended these services to be run. We use Docker because it provides all necessary dependencies in a single package rather than asking you to chase down and download dependencies for yourself.  [Install the free Docker desktop to before following the rest of this tutorial](https://docs.docker.com/get-docker/).

## Hypercane

### Installing and Running:

1. Create a new folder named `hypercane-tutorial`
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/hypercane/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1
```
cd hypercane-tutorial
```
5. Type the following command:
```
docker-compose run hypercane hc --help
```

Your output should resemble something like the following:
```
Pulling mongodb (mongo:latest)...
latest: Pulling from library/mongo
6e0aa5e7af40: Pull complete
d47239a868b3: Pull complete
49cbb10cca85: Pull complete
9729d7ec22de: Pull complete
7b7fd72268d8: Pull complete
5e2934dacaf5: Pull complete
bf9da24d4b2c: Pull complete
d2f8c3715616: Pull complete
dac42b84e850: Pull complete
0724cb122c25: Pull complete
f0fe10b8b0c1: Pull complete
28e025c87f29: Pull complete
Digest: sha256:75a5f624bd6d14254e0d84c2833f576109672750aaf2bf01d61cb5ead44f4505
Status: Downloaded newer image for mongo:latest
Pulling hypercane (oduwsdl/hypercane:latest)...
latest: Pulling from oduwsdl/hypercane
6f2f362378c5: Pull complete
494c27a8a6b8: Pull complete
7596bb83081b: Pull complete
372744b62d49: Pull complete
615db220d76c: Pull complete
39aa0c89bda1: Pull complete
ac275157d894: Pull complete
98d16dec829a: Pull complete
c8514b1c6524: Pull complete
1abaf6ed4a17: Pull complete
64fbbc1a337e: Pull complete
b3e26f4fd9d9: Pull complete
02e840f44883: Pull complete
4a37d0630236: Pull complete
af28ab122d34: Pull complete
Digest: sha256:9e4327223b2e863fdaf66b2aa3e6046420ab15c33984c72252b740842fe81f03
Status: Downloaded newer image for oduwsdl/hypercane:latest
Creating hypercane-tutorial_mongodb_1 ... done
Creating hypercane-tutorial_hypercane_run ... done
hc (Hypercane) is a framework for building algorithms for sampling mementos from a web archive collection.
It is a complex toolchain requiring a supported action and additional arguments.

For example:
    hc sample dsa1 -i archiveit -a 8778 -o story-mementos.txt

This is the list of supported actions:

    * sample
    * report
    * synthesize
    * identify
    * filter
    * cluster
    * score
    * order

For each of these actions, you can view additional help by typing --help after the action name, for example:
    hc sample --help
```

The first part will only display the first time you run docker-compose with Hypercane. It is Docker reporting that it is downloading Hypercane and the MongoDB database that it uses for caching.

Try running the `docker-compose` command again:
```
docker-compose run hypercane hc --help
```

and you see just the output from Hypercane:

```
Creating hypercane-tutorial_hypercane_run ... done
hc (Hypercane) is a framework for building algorithms for sampling mementos from a web archive collection.
It is a complex toolchain requiring a supported action and additional arguments.

For example:
    hc sample dsa1 -i archiveit -a 8778 -o story-mementos.txt

This is the list of supported actions:

    * sample
    * report
    * synthesize
    * identify
    * filter
    * cluster
    * score
    * order

For each of these actions, you can view additional help by typing --help after the action name, for example:
    hc sample --help
```


### Shutting down Hypercane:

Shutting down Hypercane involves removing its running container.

```
docker-compose rm -f
```

Note: the MongoDB container will continue running so it is ready for you to run Hypercane in the future.

## Raintale

Raintale requires MementoEmbed. If you have already followed the previous section's directions for starting MementoEmbed, stop if before executing these instructions.

### Installing and Running Raintale

1. Create a folder named `raintale-tutorial`
2. Download the file `docker-compose.yml` from https://raw.githubusercontent.com/oduwsdl/raintale/master/docker-compose.yml and save it to that folder
3. Open a terminal
4. Change to the directory you created in step 1
```
cd raintale-tutorial
```
6. Type the following command:
```
docker-compose run raintale tellstory --help
```

Your output should resemble something like the following:
```
Creating network "raintale-tutorial_default" with the default driver
Pulling mementoembed (oduwsdl/mementoembed:latest)...
latest: Pulling from oduwsdl/mementoembed
16cf3fa6cb11: Pull complete
3ddd031622b3: Pull complete
69c3fcab77df: Pull complete
a403cc031cae: Pull complete
b900c5ffbaf4: Pull complete
9d90270d16b6: Pull complete
d9ec9d535562: Pull complete
c2acb04a62c2: Pull complete
41090470e1df: Pull complete
5c9f77d4af84: Pull complete
853ba1cb2072: Pull complete
7805745e238b: Pull complete
9a83eb92a24e: Pull complete
aec58309153d: Pull complete
351ebe1f50d0: Pull complete
ba36db011b1d: Pull complete
b21ab4c384f4: Pull complete
44e421e296cc: Pull complete
5ce770a43225: Pull complete
1edda900b2f3: Pull complete
29daba2a0c69: Pull complete
addfe9e53450: Pull complete
Digest: sha256:c0d795a2326d8eafba0e54a99807a21091390d0cde7f3442ad7b66b69eee1518
Status: Downloaded newer image for oduwsdl/mementoembed:latest
Pulling raintale (oduwsdl/raintale:latest)...
latest: Pulling from oduwsdl/raintale
6f2f362378c5: Already exists
494c27a8a6b8: Already exists
7596bb83081b: Already exists
372744b62d49: Already exists
615db220d76c: Already exists
39aa0c89bda1: Already exists
ac275157d894: Already exists
98d16dec829a: Already exists
c8514b1c6524: Already exists
0cd41e2e735e: Pull complete
df1876eba761: Pull complete
e82a564ae606: Pull complete
fbcc800d6026: Pull complete
Digest: sha256:747b6057d0eb7612094ea4c8cd82c87438e8a6682704d4ebd7ebe1fd12e5e590
Status: Downloaded newer image for oduwsdl/raintale:latest
Creating raintale-tutorial_mementoembed_1 ... done
Creating raintale-tutorial_raintale_run   ... done
Beginning raintale to tell your story.
usage: /usr/local/bin/tellstory [-h] -i INPUT_FILENAME --storyteller
                                STORYTELLER [--preset STORYTELLING_PRESET]
                                [--story-template STORY_TEMPLATE_FILENAME]
                                [--title TITLE]
                                [--collection-url COLLECTION_URL]
                                [--generated-by GENERATED_BY]
                                [--generation-date GENERATION_DATE]
                                [--mementoembed_api MEMENTOEMBED_API]
                                [-l LOGFILE] [-c CREDENTIALS_FILE] [-v] [-q]
                                [-o OUTPUT_FILE]

Given a list of story elements, including URLs to archived web pages, raintale publishes them to the specified service.

optional arguments:
  -h, --help            show this help message and exit
  -i INPUT_FILENAME, --input INPUT_FILENAME
                        An input file containing the memento URLs for use in the story.
  --storyteller STORYTELLER
                        The service or file format used to tell the story. Options are:
                                * facebook - (EXPERIMENTAL) Given input data and a template file, this storyteller publishes a story as a Facebook thread.
                        	* twitter - Given input data and a template file, this storyteller publishes a story as a Twitter thread.
                        	* template - Given input data and a template file, this storyteller generates a story formatted based on the template and saves it to an output file.
                        	* video - ERROR
                        	* html - writes output to this file format, requires -o option to specify the output filename.
                        	* jekyll-html - writes output to this file format, requires -o option to specify the output filename.
                        	* jekyll-markdown - writes output to this file format, requires -o option to specify the output filename.
                        	* markdown - writes output to this file format, requires -o option to specify the output filename.
                        	* mediawiki - writes output to this file format, requires -o option to specify the output filename.


  --preset STORYTELLING_PRESET
                        The preset used for a given story, typically reflecting the
                                surrogate used to tell the story and the layout of the story.
                                * 4image-card
                        	* default
                        	* thumbnails1024
                        	* thumbnails3col
                        	* thumbnails4col
                        	* vertical-bootstrapcards-imagereel


  --story-template STORY_TEMPLATE_FILENAME
                        The file containing the template for the story.
  --title TITLE         The title used for the story.
  --collection-url COLLECTION_URL
                        The URL of the collection from which the story is derived.
  --generated-by GENERATED_BY
                        The name of the algorithm or person who created this story.
  --generation-date GENERATION_DATE
                        The generation date for this story, in YYYY-mm-ddTHH:MM:SS format. Default value is now.
  --mementoembed_api MEMENTOEMBED_API
                        The URL of the MementoEmbed instance used for generating surrogates
  -l LOGFILE, --logfile LOGFILE
                        If specified, logging output will be written to this file. Otherwise, it will print to the screen.
  -c CREDENTIALS_FILE, --credentials_file CREDENTIALS_FILE
                        The file containing the credentials needed to use a storytelling service, in YAML format.
  -v, --verbose         This will raise the logging level to debug for more verbose output
  -q, --quiet           This will lower the logging level to only show warnings or errors
  -o OUTPUT_FILE, --output-file OUTPUT_FILE
                        If needed by the storyteller, the output file to which raintale will write the story contents.
```

Again, the first part of this output will only appear the first time you run `docker-compose` for Raintale. Subsequent times will not contain the `Pull complete` messages.

### Shutting down Raintale:

Shutting down Raintale involves removing its running container.

```
docker-compose rm -f
```

## MementoEmbed

You may want to run MementoEmbed without Raintale.

### Installing and Running MementoEmbed StandAlone

1. Open a terminal
2. Tell docker to fetch the MementoEmbed image
```
docker pull oduwsdl/mementoembed
```
3. Run MementoEmbed
```
docker run -d --name mementoembed -p 5550:5550 oduwsdl/mementoembed
```
4. MementoEmbed is now available at http://localhost:5550

### Stopping and Removing MementoEmbed

1. Run the following command
```
docker stop mementoembed
```
2. To remove the container, type:
```
docker rm mementoembed
```
