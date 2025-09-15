---
title: 'BioHackrXiv: Creating a federated publishing platform'
title_short: ''
tags:
  - BioHackrXiv
authors:
  - name: Arun Isaac
    orcid: 0000-0002-6810-8195
    affiliation: 1
  - name: Egon Willighagen
    orcid: 0000-0001-7542-0286
    affiliation: 2
  - name: Tazro Ohta
    orcid: 0000-0003-3777-5945
    affiliation: 3
  - name: Toshiaki Katayama
    orcid: 0000-0003-2391-0384
    affiliation: 3
  - name: Pjotr Prins
    orcid: 0000-0002-8021-9162
    affiliation: 4
affiliations:
  - name: University College London, London, The United Kingdom
    ror: 02jx3x895
    index: 1
  - name: Dept of Translational Genomics, NUTRIM, FHML, Maastricht University, Maastricht, NL
    ror: 02jz4aj89
    index: 2
  - name: Database Center for Life Science, Research Organization of Information and Systems, Japan
    ror: 018q2r417
    index: 3
  - name: Department of Genetics, Genomics and Informatics, The University of Tennessee Health Science Center, Memphis, TN, USA
    ror: 0011qv509
    index: 4
date: September 2025
cito-bibliography: paper.bib
event: BH24EU
biohackathon_name: "BioHackathon Japan 2025"
biohackathon_url:   ""
biohackathon_location: ""
group: BioHackrXiv
# URL to project git repo --- should contain the actual paper.md:
git_url: https://github.com/biohackrxiv/bhxiv-metadata/tree/main/doc/japan_biohackathon2025
# This is the short authors description that is used at the
# bottom of the generated paper (typically the first two authors):
authors_short: First \emph{et al.}
---

# Goals

Overall goals are to have improved metadata and allow independence from OSF - though we can operate in parallel. Ideally BioHackrXiv would be a template for a federated solution for scientific publications. This is going to be a multi-hackathon job.

1. Host PDFs somewhere on the internet (IPFS? Zenodo?)
1. Start creating DOIs for such a PDF
1. Amend our hosted preview system to become a submission system
   - submit to OSF and create DOI
   - submit a PDF somewhere on the internet and create DOI
   - generate metadata and host that too

Discussion:

- What is a good document hosting provider right now that will last the next 20 years? JOSS uses Zenodo for source code hosting - that may be a next step to tie project code/data to a publication
- Is it OK to have two DOIs? If it is Zenodo people have to create a private account, maybe tied to github/ORCID?
  - a DOI is just a reference and we can point it into our RDF store with links to publications:
    + self hosted
    + zenodo
    + github
    + OSF
    + internet archive
- Can we push new submissions to the OSF API?
- Can we use AI to parse the old publications and gather metadata?

# Workflow

We'll start with OSF and Zenodo

1. User creates github repo and writes paper - metadata in JSON header (github is just an option)
1. User creates a release and submits to Zenodo (JOSS does this too)
1. User submits paper using a zenodo URL to our system
1. Editor approves/rejects submission
1. On approval we push the paper to OSF
1. We host the metadata somewhere and publish our own short URI - that points to the metadata, hosted copies and DOIs

- We should ultimately not depend on OSF, Zenodo or Github. We will create a system that allows for preview, editorial review, and even posterior peer review, for articles published somewhere on the internet with multiple copies (a hash value should guarantee the specific content of the paper).

# Introduction

The first BioHackrXiv preprint was published in 2020, using a platform based on the idea
of using Markdown [@citesAsRecommendedReading:bhxiv20], and just weeks ago, BioHackrXiv
published their 100th preprint. Machine-readable metadata added to the Markdown that is
added includes the title, keywords, the author names, their affiliations, and
details about the Biohackathon event the preprint is related to.
