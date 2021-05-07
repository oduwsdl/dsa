# Exercise – Automatically Generating Story Resources

![Hypercane Logo](https://hypercane.readthedocs.io/en/latest/_images/hypercane-logo-alpha-sm.png)

Storytelling involves reduction and visualization of the large collection to some representative samples. This algorithm was developed by Yasmin AlNoamany.

![DSA Algorithm](https://github.com/oduwsdl/dsa/raw/master/tutorials/CEDWARC-2019/images/DSA1-algorithm.png)

> For more information on how this algorithm works, see: Y. AlNoamany, M. C. Weigle, and M. L. Nelson. 2017. Generating Stories From Archived Collections. In Proceedings of the 2017 ACM on Web Science Conference. https://doi.org/10.1145/3091478.3091508

We will use [Hypercane](https://oduwsdl.github.io/hypercane/) to help us perform this reduction with [Archive-It collection 3649 "2013 Boston Marathon Bombing"](https://archive-it.org/collections/3649).

## Step 0: Identifying TimeMaps

1. Open a terminal
2. Type the following:
```
docker-compose run hypercane hc identify timemaps -i archiveit -a 3649 -o timemaps.tsv -l identify-timemaps.log
```

* `identify timemaps` is an action instructing Hypercane to identify the TimeMap URIs (URI-Ts) from the input
* `-i archiveit` tells Hypercane that the input consists of an Archive-It collection identifier
* `-a 3649` tells Hypercane to process Archive-It collection 3649
* `-o timemaps.tsv` tells Hypercane to save the URI-Ts to a file named `timemaps.tsv`
* `-l identify-timemaps.log` tells Hypercane to save log messages to a file named `identify-timemaps.log`

## Step 1: Excluding Off-Topic Pages

1. Open a terminal
2. Type the following:
```
docker-compose run hypercane hc filter include-only on-topic -i timemaps -a timemaps.tsv -o ontopic.tsv -l include-only-ontopic.log
```
3. When the prompt returns, the command has finished executing.

> If you see this at any time:
> 
```
/usr/local/lib/python3.6/dist-packages/sklearn/externals/joblib/externals/cloudpickle/cloudpickle.py:47: DeprecationWarning: the imp module is deprecated in favour of importlib; see the module's documentation for alternative uses
  import imp
```
> It is caused by a library used by the OTMT. This will not go away until that library releases a new version.


This command downloads the seed mementos for the collection and runs similarity metrics on these mementos to detect mementos that are off-topic. The arguments to the command above have the following meanings:

* `include-only on-topic` is an action instructing Hypercane to only include mementos that are on-topic
* `-i timamaps` tells Hypercane that the input consists of a list of TimeMap URIs (URI-Ts)
* `-a timemaps.tsv` tells Hypercane to use the file generated from the previous step as a list of URI-Ts
* `-o ontopic.tsv` tells Hypercane to save the list of mementos that are on-topic to a file named `ontopic.tsv`
* `-l include-only-ontopic.log` tells Hypercane to save log messages to a file named `include-only-ontopic.log`

This can take a long time depending on the size of the collection. Some examples:
* a collection with 374 seed mementos took 1 minute, 56 seconds
* a collection with 31,863 seed mementos took 3 hours 17 minutes 11 seconds
* For this reason, we will work with output from an existing run...

> Under the hood, Hypercane uses the Off-Topic Memento Toolkit to perform this step. For an analysis of the Off-Topic Memento Toolkit (OTMT), see: S. M. Jones, M. C. Weigle, and M. L. Nelson. 2018. The Off-Topic Memento Toolkit. In International Conference on Digital Preservation (iPRES) 2018. https://doi.org/10.17605/OSF.IO/UBW87

## Step 2: Excluding Duplicate Mementos

Using the same terminal, type the following:
```
docker-compose run hypercane hc filter exclude near-duplicates -i mementos -a ontopic.tsv -o non-duplicates.tsv -l exclude-near-duplicates.log
```

* `exclude near-duplicates` is an action telling Hypercane to remove near-duplicate mementos from the input
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a ontopic.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o non-duplicates.tsv` tells Hypercane to save the list of non-duplicate mementos to a file named `non-duplicates.tsv`
* `-l exclude-near-duplicates.log` tells Hypercane to save log messages to a file named `exclude-near-duplicates.log`

**Why Remove Duplicates?**

* Remember: A memento is an observation at a particular point in time
* Sometimes the web page did not change
* These duplicates are extras that we do not need in our story

![Example of duplicate mementos](https://raw.githubusercontent.com/oduwsdl/dsa/master/tutorials/CEDWARC-2019/images/duplicates.png)

The above figure contains thumbnails of duplicate mementos, grouped by color. Mementos outlined in red are the same, green are the same, etc.

## Step 3: Excluding mementos by language

Type the following:
```
docker-compose run hypercane hc filter include-only languages --lang en -i mementos -a non-duplicates.tsv -o english-only.tsv -l include-only-english.log
```

* `include-only languages` is an action telling Hypercane to only include mementos whose language matches the ones provided by the `--lang` argument
* `--lang en` is the list of languages to include, in this case English (`en`)
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a non-duplicates.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o english-only.tsv` tells Hypercane to save the list of english-only URI-Ms to `english-only.tsv`
* `-l include-only-english.log` tells Hypercane to save log messages to a file named `include-only-english.log`

**Why keep mementos with the same language?**

![Example of mementos in different languages](https://raw.githubusercontent.com/oduwsdl/dsa/master/tutorials/CEDWARC-2019/images/languages.png)

We typically want to tell stories with a single language.

## Step 4: Slice the mementos by datetime

Type the following:
```
docker-compose run hypercane hc cluster time-slice -i mementos -a english-only.tsv -o sliced.tsv -l time-slicing.log
```

* `cluster time-slice` is an action telling Hypercane to slice the collection by memento-datetime (when each memento was captured)
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a english-only.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o sliced.tsv` tells Hypercane to save the list of sliced URI-Ms to `sliced.tsv`, this file consists of the URI-Ms and their slice numbers
* `-l time-slicing.log` tells Hypercane to save log messages to a file named `time-slicing.log`

**Why slice the collection?**

To ensure we account for the spread across time, we slice the collection dynamically and distribute the mementos equally on the slices.

For N mementos:
* If |N| <= 28, then the number of slices is |N|
* If |N| > 28, then the number of slices is: ⌈ 28 + log<sub>10</sub> |N| ⌉

This way the size of the story grows slowly as needed for large collections


## Step 5: Cluster the mementos in each slice

Type the following:
```
docker-compose run hypercane hc cluster dbscan --feature tf-simhash  -i mementos -a sliced.tsv -o sliced-and-clustered.tsv -l time-sliced-and-dbscan-clustered.log
```

* `cluster dbscan` is an action telling Hypercane to cluster the collection with the DBSCAN algorithm
* `--feature tf-simhash` tells Hypercane to apply DBSCAN to the Term Frequency Simhash distance of each memento from each other
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a sliced.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o sliced-and-clustered.tsv` tells Hypercane to save the list of sliced URI-Ms to `sliced-and-clustered.tsv`, this file consists of the URI-Ms their slice numbers from the previous step, and their cluster numbers from this step
* `-l time-sliced-and-dbscan-clustered.log` tells Hypercane to save log messages to a file named `time-sliced-and-dbscan-clustered.log`

**Why cluster the slices?**

To ensure we find novel mementos, we reuse the Simhash scores from the deduplication step. Each cluster is built from the distance between these Simhash scores using the DBSCAN algorithm.

## Step 6: Choose High Quality Pages From Each Cluster

* We favor pages with the following features:
  - News over social media, because social media posts produce poorer cards
  - Longer URLs with deeper paths, because they contain more unique information and thus produce better cards
  - They have low memento damage
  
**What is “Memento Damage” ?**
 
Sometimes, when crawling, a web archive does not acquire all of the images, stylesheets, or JavaScript to render a page. This lack of resources is called **damage** and is assigned a score.

> Note that calculating memento damage takes a long time, so this next step will take a while.
> Because it takes a while, we will skip the Memento-Damage step during our lesson today.
> Instead, let's visit http://memento-damage.cs.odu.edu/ for an example.

> For more information on Memento Damage, see: Brunelle, J.F., Kelly, M., SalahEldeen, H. et al. International Journal on Digital Libraries (2015) 16: 283. https://doi.org/10.1007/s00799-015-0150-6

### The Command to Select High Quality Pages

Type the following:
```
docker-compose run hypercane hc score dsa1-scoring -i mementos -a sliced-and-clustered.tsv -o scored.tsv -l dsa1-scored.log
```

* `score dsa1-scoring` is an action telling Hypercane to score the collection by AlNoamany's scoring function
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a sliced-and-clustered.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o scored.tsv` tells Hypercane to save the list of sliced URI-Ms to `scored.tsv`, this file consists of the URI-Ms their slice and cluster numbers previous steps, and their scores from this step
* `-l dsa1-scoring.log` tells Hypercane to save log messages to a file named `dsa1-scoring.log`

## Step 7: Keep Highest Scoring Pages From Each Cluster

Type the following:
```
docker-compose run hypercane hc filter include-only highest-score-per-cluster -i mementos -a scored.tsv -o highest-scored.tsv -l highest-scored-per-cluster.log
```

* `include-only highest-score-per-cluster` is an action telling Hypercane to include only the memento from each cluster that scored highest
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a scored.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o highest-scored.tsv` tells Hypercane to save the list of sliced URI-Ms to `highest-scored.tsv`, this file consists of the URI-Ms their slice and cluster numbers previous steps, and their scores from this step
* `-l highest-scored-per-cluster.log` tells Hypercane to save log messages to a file named `highest-scored-per-cluster.log`

### Step 8: Ordering the Mementos By Memento-Datetime

Type the following:
```
docker-compose run hypercane hc order pubdate-else-memento-datetime -i mementos -a highest-scored.tsv -o ordered.tsv -l ordered-mementos.log
```

* `order pubdate-else-memento-datetime` is an action telling Hypercane to include only the memento from each cluster that scored highest
* `-i mementos` tells Hypercane that the input consists of a list of memento URIs (URI-Ms)
* `-a highest-scored.tsv` tells Hypercane to use the file from the previous step as a list of URI-Ms
* `-o ordered.tsv` tells Hypercane to save the list of sliced URI-Ms to `ordered.tsv`, this file consists of the URI-Ms their slice and cluster numbers previous steps, and their scores from this step
* `-l ordered-mementos.log` tells Hypercane to save log messages to a file named `ordered-mementos.log`

With this list in `ordered.tsv`, we can now visualize our story

[Back to Table of Contents](README.md)
