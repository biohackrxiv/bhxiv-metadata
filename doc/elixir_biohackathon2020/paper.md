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
affiliations:
  - name: Department of Genetics, Genomics and Informatics, The University of Tennessee Health Science Center, Memphis, TN, USA.
    index: 1
  - name: Database Center for Life Science, Research Organization of Information and Systems, Japan
    index: 2
date: 15 November 2020
bibliography: paper.bib
event: Elixir2020
group: BioHackrXiv Group
authors_short: Pjotr Prins & \emph{et al.}
---

# Introduction

https://biohackrxiv.org/ is a scholarly publication service for
biohackathons and codefests where papers are generated from markdown
templates where the header is a YAML/JSON record that includes the
title, authors, affiliations and tags. Currently the publications are
hosted at osf.io, a free, open source web application that connects
and supports the research workflow, enabling scientists to increase
the efficiency and effectiveness of their research. OSF is run by the
non-profit Center for Open Science (COS) and charges for the handing
out of digital object identifiers (DOIs). The OSF site provides
support for basic editorial functions and displaying PDFs. More
importantly it has a basic search infrastructure.

Many projects in biohackathons are about using FAIR data. The OSF site
lacks a number of facilities. For example it is not easy to
straightforward to list publications related to certain biohackathons,
e.g. `biohackathon 2019 Japan'. Another problem is that there is no
clear link between publications and the projects they refer to. It is
necessary to read the PDF for that. Because the current setup is
lacking in the findable (F) and accessible (A) of FAIR we decided to
add a side-service that provides a SPARQL end point for queries and
some simple HTML output that can be embedded in a BioHackathon
website.

# Results

<!--
    State the problem you worked on
    Give the state-of-the art/plan
    Describe what you have done/results starting with The working group created...
    Write a conclusion
    Write up any future work
-->

## Linking metadata up

To connect the main publication with its source and related markdown
we maintain a [list](./etc/papers.yaml) that needs to be updated with
every publication. This file contains hard links we can not easily
acquire in other ways. E.g.

```yaml
papers:
- id: https://biohackrxiv.org/km9ux/
  doi: https://doi.org/10.37044/osf.io/km9ux
  markdown: https://raw.githubusercontent.com/journal-of-research-objects/Example-BioHackrXiv-Paper/master/paper.md
```

The markdown link should be able to fetch the parseable file.

## Transform metadata to RDF

In the next step we take markdown file and tranform that into RDF, the
language of the semantic web, using a small subset of the scholarly
publication [ontology](https://schema.org/ScholarlyArticle) from
schema.org [cite].

In the first version we opted to generate RDF with Ruby erb templates
which means that validation happens in the source code. Some semantic
enrichment includes URIs for the biohackathons themselves.

In future work we could introduce Shex to validate entries and the
scholarly annotation can be expanded. For example we could parse the
number of downloads and other information from the OSF.io website and
transform that into RDF. We can also add indexing services, such as
Pubmed Central and Google Scholar.

# Discussion

Even though OSF.io does not provide all the functionality we require
for BioHackrXiv, we are able to work around limitations and our
functionality may be merged or linked into the main
https://biohackrxiv.org/ website.

Add notes on:

1. Add metadata to markdown, e.g. for main source code repo

## Acknowledgements

We thank the organizers of the Elixir BioHackathon 2020 and DBCLS
for sponsoring the COS facilities.

## References
