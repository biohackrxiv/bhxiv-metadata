---
title: 'Metadata for BioHackrXiv markdown publications'
title_short: 'Metadata for BioHackrXiv'
tags:
  - metadata RDF pre-prints
authors:
  - name: Mats Perk
    affiliation: 4
  - name: Arun Isaac
    orcid: 0000-0002-6810-8195
    affiliation: 1
  - name: Tazro Ohta
    orcid: 0000-0003-3777-5945
    affiliation: 2
  - name: Egon Willighagen
    orcid: 0000-0001-7542-0286
    affiliation: 3
  - name: Leyla Garcia Castro
    affiliation: 5
    orcid: 0000-0003-3986-0510
  - name: Toshiaki Katayama
    orcid: 0000-0003-2391-0384
    affiliation: 2
  - name: Pjotr Prins
    orcid: 0000-0002-8021-9162
    affiliation: 1
affiliations:
  - name: Department of Genetics, Genomics and Informatics, The University of Tennessee Health Science Center, Memphis, TN, USA.
    index: 1
  - name: Database Center for Life Science, Research Organization of Information and Systems, Japan
    index: 2
  - name: Department of Bioinformatics - BiGCaT, Maastricht University, Maastricht, The Netherlands
    index: 3
  - name: Turku Bioscience Centre, University of Turku, Turun yliopisto, Finland
    index: 4
  - name: Knowledge Management Group, at ZBMED Information Centre for life sciences
    index: 5
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

In this paper we present the work executed on BioHackrXiv during the Elixir Biohackathon in Paris, 2022.
Over thirty papers have been published through this system and with the amount of biohackathons and codefests increasing every year, we expect this type of reporting and publishing to continue.
The goal was to further improve deployment and takeup of the web service and to set a roadmap for improving the workflow and explore integration of EuropePMC, OpenCitation and Zenodo services (cite?).

[BioHackrXiv](https://biohackrxiv.org/) is a scholarly publication service for
biohackathons and codefests.
BioHackrXiv publications are generated from markdown/LaTeX templates where the header is a YAML/JSON record that includes the title, authors, affiliations and tags. The idea originated from the [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) layout (cite?) that is used in the Journal of Open Source Software (JOSS)[@JOSS] where Prins used to be part of the editorial board (cite?).
Templates are provided as an [example](https://github.com/biohackrxiv/publication-template).

As described in the Elixir 2020 Biohackathon paper (cite?) metadata is crucial to publications, including acquiring a digital object identifier (DOI). DOIs are permanent URIs to PDFs, so publications can be cited by others. One interesting aspect is that DOIs support versioning - that means papers can be updated under the same DOI, this is not the case with content-addressable identifiers, such as IPFS (cite?).

In the existing workflow we host BioHackrXiv.org as a --- so called --- preprint service with the Open Science Foundation (OSF). OSF manages the publication submission system and creates a DOI on acceptance. A DOI may look like \url{https://doi.org/10.37044/osf.io/km9ux} and should resolve to a hosted PDF.

For the authors, the current setup, demands writing a paper in a git repository using pandoc flavoured markdown that allows for embedded LaTeX. We wrote a preview webservice at \url{http://preview.biohackrxiv.org/} that generates a nice looking PDF from a pasted git URL, or alternatively a zipped up file containing paper.md and paper.bib. Next, the main author has to submit the paper through the OSF managed preprint system.
After a cursory check, one of the editors of BioHackrXiv will accept or reject the paper -- mostly as a curation step against SPAM. After acceptance the paper appears online with a DOI and automatically gets included in the EU PMID or EuropePMID, followed by OpenCitations.

Even though the system works as a `minimal viable product', and the PDF generation and submission works rather well, we identified a number of problems with the existing workflow:

1. Authors have to submit some information twice - particularly author names - which is prone to mistakes (missing authors, misspellings)
1. In previous biohackathons we engineered a metadata graph that exports publications and their authors. Updating this graph includes some manual steps and that causes significant delays in updating the graph
1. When authors choose to submit a zip file we have to contact the authors for all relevant metadata
1. The current system can not include accompanying code and data with the submission
1. The preview service has a limitation of one paper per git repository --- this often confuses authors

We identified these challenges and decided we need to automate more and work on the mechanism of submitting and generating publications and their metadata. In this biohackathon, in addition to fixing bugs and helping other groups format their biohackathon publications, we visited OSF, Zenodo, and OpenCitations APIs and RDF, wrote proof-of-concept code, and this resulted in a new road map for BioHackrXiv.

# Results

## TODO

* Mermaid on pandoc
* i8n support

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
  - https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=doi:10.37044/osf.io/8qdse&format=dc
* Includes misspellings
* With abstract
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


## OSF API (Mats)

## Virtuoso as a system container (Arun)

BioHackrXiv uses RDF to track metadata on publications, parsed directly from the markdown documents that are submitted. The preview webserver, for example, queries the graph and caches the result in memory. The main RDF store and SPARQL endpoint runs in virtuoso-ose and for this biohackathon we decided to create a GNU Guix system container - that allows easy deployment of the full service anywhere. The definition is [here](https://github.com/genenetwork/genenetwork-machines/commit/3cebfb3e30e903851aefb2f997d8847d3f0ddee4) with the public SPARQL endpoint https://sparql.genenetwork.org/sparql

## Hackathon integration (Pjotr)

* Added secondary preview after updating Guix http://biohackrxiv.genenetwork.org/
* Fediverse

## Enhancements

* Unit tests
* CITO
* LaTeX
* Template

Templates are provided as an
[example](https://github.com/biohackrxiv/publication-template). So far, some 30 papers have been published through this system.

# Discussion

BioHackrXiv allow projects to publish their work as a citeable resource in the form of non-peer reviewed pre-published papers. A minority of these may end up as a peer reviewed paper. Even so, getting citeable resources is valuable and work done at biohackathons does not get lost this way.

## Repositories

We invite contributions to parsing and adding relevant metadata to
BioHackrXiv RDF. Simply do a pull request on
https://github.com/biohackrxiv/bhxiv-metadata. The web server examples
are hosted on https://github.com/biohackrxiv/bhxiv-gen-pdf.

## Acknowledgements

We thank the organizers of the Elixir BioHackathon 2020 for the event.
We also thank DBCLS for sponsoring the OSF.io hosting of BioHackrXiv.

## References
