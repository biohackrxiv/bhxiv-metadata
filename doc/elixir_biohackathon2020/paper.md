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

## Linking up

Future work includes:

# Discussion

Even though OSF.io does not provide all the functionality we require
for BioHackrXiv, we are able to work around limitations and our
functionality may be merged or linked into the main
https://biohackrxiv.org/ website.

## Acknowledgements

We thank the organizers of the Elixir BioHackathon 2020 and DBCLS
for sponsoring the COS facilities.

## References
