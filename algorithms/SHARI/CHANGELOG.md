# SHARI ChangeLog

As the SHARI process evolves, this CHANGELOG will keep track of the changes to the individual tools, scripts, and relationships to the platforms that support the process.

## 2020-09-16

* removed machine-specific path from twitter script (committed on 10/7)

## 2020-09-13

* updated striking image download and post assignment for SHARI DSA puddles to adapt to Linux sed and macOS sed (committed on 10/7)

## 2020-09-11

* ODUCS updated docker-compose.yml to use the host machine's resolv.conf for DNS resolution in restricted environments

## 2020-09-06

* updated StoryGraph Toolkit to v0.0.6

## 2020-08-06

* added "flipboard advertisements" to stopword list

## 2020-08-03

* create_storygraph_story.sh now reruns the memento creation step 3 times 5 minutes apart in hopes that the Internet Archive will stop returning 500 status codes in the interim 

## 2020-07-21

* SHARI scripts now completely rely upon Docker images for the components

## 2020-07-19

* tested with new version of sumgram, but encountered issues, so rolled back to sumgram v0.0.16
* centralized scripts to this repository
* updated Hypercane version to the one that:
    * supports ArchiveNow's new configurable session objects
    * supports configurable stopwords

## 2020-07-15

* updated sumgram stopword list with
    * facebook whatsapp
    * mail flipboard

## 2020-06-21

* upgraded to StoryGraph Toolkit v0.0.4 which includes a fix for determining a given date's biggest story

## 2020-06-20

* updated sumgram stopword list in Hypercane to include common social media sumgrams
    * pinterest reddit
    * print mail
    * reddit print
    * whatsapp pinterest
    * subscribe whatsapp

## 2020-06-12

* after testing, we fixed the version of StoryGraph Toolkit to v0.0.2

## 2020-06-08

* changed the DSA-Puddles web site to use summary_large_format for cards

## 2020-05-21

* added document frequency to Hypercane output
* changed Raintale template to display the document frequency next to each sumgram

## 2020-04-06

* added a script that tweets each SHARI story daily

## 2020-04-01

* the SHARI process goes live
