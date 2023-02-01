---
title: 'CiTO support for BioHackrXiv'
title_short: 'CiTO support for BioHackrXiv'
tags:
  - metadata RDF pre-prints
authors:
  - name: Egon Willighagen
    orcid: 0000-0001-7542-0286
    affiliation: 1
  - name: Tazro Ohta
    orcid: 0000-0003-3777-5945
    affiliation: 2
  - name: Leyla Jael Castro
    orcid: 0000-0003-3986-0510
    affiliation: 3
  - name: Pjotr Prins
    orcid: 0000-0002-8021-9162
    affiliation: 4
affiliations:
  - name: Department of Bioinformatics - BiGCaT, Maastricht University, Maastricht, The Netherlands
    index: 1
  - name: Database Center for Life Science, Research Organization of Information and Systems, Japan
    index: 2
  - name: ZB MED Information Centre for Life Sciences, Germany
    index: 3
  - name: Department of Genetics, Genomics and Informatics, The University of Tennessee Health Science Center, Memphis, TN, USA.
    index: 4
date: 26 January 2023
cito-bibliography: paper.bib
event: BH21EU
biohackathon_name: "BioHackathon Europe"
biohackathon_url:   "https://biohackathon-europe.org/"
biohackathon_location: "Barcalona, Spain, 2021"
group: Logic programming group
git_url: https://github.com/biohackrxiv/bhxiv-gen-pdf
authors_short: Egon Willighagen, Tazro Otha, Pjotr Prins
---

# Introduction

In this paper we present the work executed on BioHackrXiv during the international ELIXIR BioHackathon in Barcelona, Spain, 2021.
[BioHackrXiv](https://biohackrxiv.org/) is a scholarly publication service for
biohackathons and codefests that target biology, bioinformatincs and the biomedical sciences in the spirit of pre-publishing
platforms&nbsp;[@citesAsRecommendedReading:preprints].
Over thirty papers have been published through this system and with the amount of biohackathons and codefests increasing every year, we expect this type of reporting and publishing to continue.
The goal for this biohackathon was to add CiTO support and further improve deployment and take-up of the web service.
CiTO is the Citation Typing Ontology that enables characterization of the nature or type of citations, both factually and
rhetorically&nbsp;[@citesAsAuthority:CiTO; @citesAsAuthority:Willighagen2020].
For examples see the [References] of this paper. A full list of characterizations can
be found at [https://purl.org/spar/cito](https://purl.org/spar/cito). These enriched references containing CiTO characterizations can become
part of the wider metadata on publications.

BioHackrXiv publications are generated from simple powerful markdown/LaTeX templates where the header is a YAML/JSON record that includes the title, authors, affiliations and tags&nbsp;[@citesAsAuthority:bhxiv20]. The idea originated from the [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) layout that is used in the Journal of Open Source Software
(JOSS)&nbsp;[@citesAsAuthority:JOSS].
Templates are provided as an [example](https://github.com/biohackrxiv/publication-template). Support in pandoc of CiTO annotations dates
back to 2017&nbsp;[@usesMethodIn:Krewinkel2017].

# Results

## CiTO support

The Citation Typing Ontology&nbsp;[@usesMethodIn:CiTO] provides a framework to annotation citations
with the reasons ("intention") why that citation is made. For example, you can cite an article
because it describes data or a method you are using. Or you are citing the article because
you disagree with it.

Despite the long history, it is not widely used yet. The Springer Nature
_Journal of Cheminformatics_, however, started in 2020 a pilot with using CiTO
annotation&nbsp;[@citesAsAuthority:Willighagen2020]. As part of this pilot, [Lua](https://www.lua.org/) scripts were developed
that would allow the citation typing to happen when the citation was made.

The tool to convert BioHackrXiv Markdown to PDF has now been extended with an updated
Lua filter to work with the APA Citation Styling Language (CSL, see [https://citationstyles.org/](https://citationstyles.org/)),
different from the CSL used by the _Journal of Cheminformatics_).

## Achievements

During the week, we implemented various new features and ended up with the following achievements
at the end of the BioHackathon (including some non-CiTO-related outcomes):

1. We updated the software that runs the BioHackrXiv PDF generation service
2. We added CiTO support and now can annotate the bibliography in Markdown for PDF generation
3. We added Scalable Vector Graphics (SVG) support to allow people to add high-resolution figures
4. CiTO support with recent CSL
5. SVG support
6. Added Resource Descriptino Framework (RDF) support
7. Updated software stack
8. Added tests
9. Tested the new preview generator
10. Support BioHackathon groups with their publications

## Future work

At this point we identify the following tasks that we can work on:

1. Add the CiTO information to a public resource
2. Add CiTO information to our own RDF store
2. Support other group papers
3. Bring CiTO to the Journal of Open Source Software (JOSS)
4. Improve RDF/Wikidata/OpenCitations with CiTO
5. More info on the Open Science Foundation (OSF) [preprints pages](https://osf.io/preprints/), i.e., the platform where BioHackrXiv preprints are hosted
6. Support multiple papers in one repo by giving a full (git) path

Future changes will be integrated into the PDF online generator tool for BioHackarxiv, see http://preview.biohackrxiv.org/, so the PDF generation becomes richer and easier for submitters.

# Discussion

As part of the ELIXIR BioHackathon 2021 we added CiTO support for BioHackrXiv.
CiTO is an extension that is supported by a Lua filter of pandoc and the modified filter is now available for
other publications using [pandoc](https://pandoc.org/) too.
At the time of submission (early 2023), we note that there are two BioHackrXiv preprints
that have used CiTO annotation&nbsp;[@citesAsDataSource:Ammar2022ETL; @citesAsDataSource:Arend2022BioHackEU22].

# Repositories

We invite contributions to parsing and adding relevant metadata to
BioHackrXiv RDF. Simply do a pull request on
https://github.com/biohackrxiv/bhxiv-metadata. The web server examples
are hosted on https://github.com/biohackrxiv/bhxiv-gen-pdf.

# Acknowledgements

We thank the organizers of the ELIXIR BioHackathon 2021 and ELIXIR BioHackathon 2022 events
and the early adopters at the ELIXIR BioHackathon 2022 who added CiTO annotations to their preprints.
We also thank Database Center for Life Science (DBCLS) for sponsoring the OSF.io hosting of BioHackrXiv.


# References
