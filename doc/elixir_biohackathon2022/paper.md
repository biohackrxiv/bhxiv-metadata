---
title: 'Metadata for BioHackrXiv markdown publications'
title_short: 'Metadata for BioHackrXiv'
tags:
  - metadata RDF pre-prints
authors:
  - name: Pjotr Prins
    orcid: 0000-0002-8021-9162
    affiliation: 1
  - name: Tazro Ohta
    orcid: 0000-0003-3777-5945
    affiliation: 2
  - name: Egon Willighagen
    orcid: 0000-0001-7542-0286
    affiliation: 3
affiliations:
  - name: Department of Genetics, Genomics and Informatics, The University of Tennessee Health Science Center, Memphis, TN, USA.
    index: 1
  - name: Database Center for Life Science, Research Organization of Information and Systems, Japan
    index: 2
  - name: Department of Bioinformatics - BiGCaT, Maastricht University, Maastricht, The Netherlands
    index: 3
date: 15 November 2022
cito-bibliography: paper.bib
event: BIO22EU
biohackathon_name: "BioHackathon Europe"
biohackathon_url:   "https://biohackathon-europe.org/"
biohackathon_location: "Paris, France, 2022"
group: BioHackrXiv
git_url: https://github.com/biohackrxiv/bhxiv-gen-pdf
authors_short: Pjotr Prins, Tazro Otha, Egon Willighagen
---

# Introduction

https://biohackrxiv.org/ is a scholarly publication service for
biohackathons and codefests where papers are generated from markdown
templates where the header is a YAML/JSON record that includes the
title, authors, affiliations and tags. The idea originated from the
markdown layout used in the Journal of Open Source Software
(JOSS)[@JOSS]. Templates are provided as an
[example](https://github.com/biohackrxiv/submission-templates).

* Describe current method through OSF

# Results

## TODO

* Mermaid on pandoc

## Zenodo API (Arun)

## OpenCitations (Mats)

* Contains papers that cite each other
* Uncited papers not included
* Data fetched from europmc.org
* Includes DOI
* Includes misspelled authors
* ORCID?
* Takes time to sync

* europepmc is complete
* europepmc exposes RDF from REST API
* Includes misspellings
* Wel abstract
* Missing ORCID

Missing metadata and wrong metadata from europepmc
Missing papers from opencitations

Conclusion: kunnen niet zonder metadata, we need to validate europepmc with the paper metadata.

Solution: write our own uploader that can push to OSF and/or Zenodo to get an API.
Advantage: choice for DOI generation. No double input for author name. Automatic ORCIDs and other metadata.

See if we can use the OSF API for this.

You seem to be able to create & upload preprint via the api in /v2/prerpints,
as described [here](https://developer.osf.io/#operation/preprints_create),
for local reference, you can clone the docs [here](https://github.com/CenterForOpenScience/developer.osf.io) and then check the files `osf-docs/swagger-spec/preprints/list.yaml` and `osf-docs/swagger-spec/preprints/definition.yaml`.
A well documented test-case can be found [here](https://raw.githubusercontent.com/CenterForOpenScience/osf-selenium-tests/develop/api/osf_api.py) which can start as a good launch-off point.
## Virtuoso as a system container (Arun)

BioHackrXiv uses RDF to track metadata on publications, parsed directly from the markdown documents that are submitted. The preview webserver, for example, queries the graph and caches the result in memory. The main RDF store and SPARQL endpoint runs in virtuoso-ose and for this biohackathon we decided to create a GNU Guix system container - that allows easy deployment of the full service anywhere. The definition is [here](https://github.com/genenetwork/genenetwork-machines/commit/3cebfb3e30e903851aefb2f997d8847d3f0ddee4) with the public SPARQL endpoint https://sparql.genenetwork.org/sparql

## Hackathon integration (Pjotr)

* Added secondary preview after updating Guix http://biohackrxiv.genenetwork.org/

# Discussion

## Repositories

We invite contributions to parsing and adding relevant metadata to
BioHackrXiv RDF. Simply do a pull request on
https://github.com/biohackrxiv/bhxiv-metadata. The web server examples
are hosted on https://github.com/biohackrxiv/bhxiv-gen-pdf.

## Acknowledgements

We thank the organizers of the Elixir BioHackathon 2020 for the event.
We also thank DBCLS for sponsoring the OSF.io hosting of BioHackrXiv.

## References
