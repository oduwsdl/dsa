# SHARI ChangeLog

As the SHARI process evolves, this CHANGELOG will keep track of the changes to the individual tools, scripts, and relationships to the platforms that support the process.

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
