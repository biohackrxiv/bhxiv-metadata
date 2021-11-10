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
date: 15 November 2021
bibliography: paper.bib
event: Elixir2021
group: BioHackrXiv Group
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

# Results

## Wednesday progress report (presented by Egon)

Achievements:

1. To crush bit rot we updated the software to run the biohackrxiv PDF generation service
2. We added CiTO support and now can annotate the bibliography in markdown for PDF generation
3. We are adding SVG support

Next steps:

1. Add the CiTO information to a public resource
2. Add CiTO information to our own RDF store
3. Test the new preview generator - and add some tests
4. Support biohackathon groups with their publications (let's get 30 publications in 2021!)

# Discussion

As part of the Elixir Biohackathon 2021 we added
CiTO support
for BioHackrXiv.


## Repositories

We invite contributions to parsing and adding relevant metadata to
BioHackrXiv RDF. Simply do a pull request on
https://github.com/biohackrxiv/bhxiv-metadata. The web server examples
are hosted on https://github.com/biohackrxiv/bhxiv-gen-pdf.

## Acknowledgements

We thank the organizers of the Elixir BioHackathon 2020 for the event.
We also thank DBCLS for sponsoring the OSF.io hosting of BioHackrXiv.

## References
