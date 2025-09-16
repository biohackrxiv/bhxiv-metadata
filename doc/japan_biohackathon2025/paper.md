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

# Day 2

- Claude AI will fetch metadata from PDF to JSON - probably possible through an API route
- OSF can accept papers through API or users can create preprint?
- Possible to become a DOI provider, but we may want to use Zenodo first to archive papers
- OSJ is a very active project to create a journal. Over 50K journals! But no metadata support just yet. Requires PHP+mysql.
- JOSS: brilliant markdown - but github dependency
- Nanopublications - Java server, key signing, but no PDF support
- We have API access to Zenodo
- We can take an OSF PDF and push it to Zenodo with metadata for 2nd DOI
- Later people can opt to skip OSF route and only push to Zenodo
- PDFs+metadata can reside anywhere
- We'll publish full RDF metadata once per year

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

The first BioHackrXiv preprint was published in 2020, using a platform based on the idea of using Markdown [@citesAsRecommendedReading:bhxiv20], and BioHackrXiv can be considered a preprint success with over 119 publications (per September 2025) with over 30 publication added per year. Machine-readable metadata is added to the Markdown that is added includes the title, keywords, the author names, their affiliations, and details about the Biohackathon event the preprint is related to.

# Results

## Getting metadata from existing publications

We used Claude we were able to extract information from an existing PDF, including ROR information. See fig{extract}.

![Example of Claude extracting metadata from a PDF in JSON format \label{extract}](./claude-extract.png)

Even at a risk of some hallucination, it appears it is feasible to scan all publications this way to build up the metadata we require. This makes it less urgent to collect metadata at time of submission.

## OJS

Since 2010 OJS has 200+ contributers, where 5 large ones. Some 5K PRs - only 250 open. According to sloccount

```
Total Physical Source Lines of Code (SLOC)                = 46,473
```

Some 80% PHP code (unfortunately). The main dependency is a SQL database. No markdown support, however.

## JOSS
