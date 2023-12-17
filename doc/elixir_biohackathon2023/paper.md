---
title: 'Persistence and metadata collection for BioHackrXiv'
title_short: 'Persistence and metadata collection for BioHackrXiv'
tags:
  - metadata RDF pre-prints
authors:
  - name: Arun Isaac
    orcid: 0000-0002-6810-8195
    affiliation: 4
  - name: Yuhao Wang
    affiliation: 3
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
  - name: University College London, London, The United Kingdom
    index: 4
  - name: Knowledge Management Group, at ZBMED Information Centre for life sciences
    index: 5
date: 3 November 2023
cito-bibliography: paper.bib
event: BIO23EU
biohackathon_name: "BioHackathon Europe"
biohackathon_url: "https://biohackathon-europe.org/"
biohackathon_location: "Barcelona, Spain, 2023"
group: BioHackrXiv
git_url: https://github.com/biohackrxiv/bhxiv-gen-pdf
authors_short: Arun Isaac, Yuhao Wang et al.
---

# Introduction

In this paper, we present the work executed on BioHackrXiv during the international Elixir BioHackathon 2023 in Barcelona, Spain. [BioHackrXiv](https://biohackrxiv.org/) is a scholarly publication service for biohackathons and codefests that target biology and the biomedical sciences in the spirit of pre-publishing platforms [@citesAsRecommendedReading:preprints]. Over sixty papers have been published through this system and with the amount of biohackathons and codefests increasing every year, we expect this type of reporting and publishing to continue. The goal for this BioHackathon was to improve deployment, enable better collection of metadata, and improve long-term archiving of user repositories.

BioHackrXiv publications are generated from simple powerful markdown/LaTeX templates where the header is a YAML/JSON record that includes the title, authors, affiliations and tags. The idea originated from the [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) layout that is used in the Journal of Open Source Software (JOSS)[@citesAsAuthority:JOSS]. Templates are provided as an [example](https://github.com/biohackrxiv/publication-template).

As described in the BioHackrXiv Elixir 2020 Biohackathon paper (in preparation), metadata is crucial to publications, including acquiring a digital object identifier (DOI). DOIs are permanent URIs to PDFs, so publications can be cited by others. One interesting aspect is that DOIs support versioning - that means papers can be updated under the same DOI, this is not the case with content-addressable identifiers, such as the Interplanetary File System (IPFS).

In the existing workflow we host BioHackrXiv.org as *pre-print* service with the Open Science Foundation (OSF.io). OSF manages the publication submission system and creates a DOI on acceptance. A DOI may look like \url{https://doi.org/10.37044/osf.io/km9ux} and should resolve to a hosted PDF.

For the authors, the current setup demands writing a paper in a git repository using [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) that allows for embedded LaTeX. We wrote a preview web service at \url{http://preview.biohackrxiv.org/} that generates a nice looking PDF from a pasted git URL, or alternatively a zipped up file containing paper.md and paper.bib. Next, the main author has to submit the paper through the OSF managed pre-print system. After a cursory check, one of the editors of BioHackrXiv will accept or reject the paper -- mostly as a curation step against spam. After acceptance the paper appears online with a DOI and automatically gets included in the EU PMID or EuropePMID, followed by OpenCitations.

# Roadmap

A plan of action for a future incarnation of BioHackrXiv was formulated. A detailed description and discussion follows.

## Current system

As it stands, BioHackrXiv only provides a PDF generation service at preview.biohackrxiv.org. Users upload a git repository or a ZIP archive, and a PDF paper is generated. Once they are happy with the generated paper, the user uploads it manually to the OSF preprints server. BioHackrXiv itself does not retain any memory of the PDFs it generated. All metadata such as author information, BioHackathon event, etc. is lost. The git repository or ZIP archive that was used to generate the PDF is also not retained. State management in curation of publications is outsourced to the OSF preprints server. This means, among other consequences, that there is no way for BioHackrXiv to display a list of accepted publications.

The current implementation of BioHackrXiv is simple in that the preview server is a pure function that rentains no state. This makes it easy to deploy and maintain for there is no state to keep safe and backup. But, the lack of state is also fundamentally limiting because some state is essential to displaying a list of accepted publications.

![Current system architecture](current.svg)

## Proposed system
### Persisting user git repositories for posterity

Git repositories provided by the user are usually hosted on GitHub. These repositories are unstable, and may be changed or deleted by the user at a later time. ZIP archives submitted by the user are, of course, ephemeral. In order for these to be archived for posterity, we need to persist these properly. We decided on persisting these as research artifacts on Zenodo. This not only gives us safe archiving for the foreseeable future, but also provides us a DOI with which to reference the git repository as a research artifact.

### Curation

We need to upload to Zenodo without troubling the user with another manual upload step. Besides, we must only upload approved publications to Zenodo, not everytime the user generates a PDF preview. This means that we can no longer outsource curation management to the OSF preprints server. The BioHackrXiv server needs to manage curation itself. If we are to implement all this, we might as well make it doubly convenient to the user by also automating uploading to the OSF preprints server.

### API accounts on OSF and Zenodo

In the proposed system, the BioHackrXiv server uploads to OSF and Zenodo, not the user. This means that the BioHackrXiv server must manage accounts on OSF and Zenodo. All uploads must go through these accounts and we must be careful not to run afoul of rate limits. Attribution of published works must also be correctly attributed to the authors and not to the BioHackrXiv server. As a result, it may be better to *link* (for example, through something like OAuth) the author's own OSF and Zenodo accounts to BioHackrXiv and use that to upload published works.

### Summary

In summary, here's how the new proposed system would work. The user only uploads their git repository or ZIP archive to BioHackrXiv. Once they are happy with the generated paper, they click a *Submit for approval* button. This puts their submission into a curation queue. Once a curator approves, the user's submission is automatically uploaded both to Zenodo and to OSF via their respective APIs.

![Proposed system architecture](proposed.svg)

## Persisting paper repositories as permanent research artifacts on Zenodo

The git repository containing the BioHackrXiv paper is usually hosted by users on GitHub. These repositories are not stable, and may be deleted by users.

## OSF API

BioHackrXiv uses OSF as a web service to manage the workflow for PDF submission, editorial review, DOI generation, PDF view and basic search. There are a number of limitations (see introduction) and during this biohackathon we explored if we can use the OSF API to create our own submission system.

One of the cool aspects of OSF is that its web UI services use their own REST API to create the functionalities. This means that we, in theory, can use the REST API to roll our own.

According to the documentation it is possible to create & upload PDFs via the API in /v2/preprints, as described [here](https://developer.osf.io/#operation/preprints_create). The docs can be found [here](https://github.com/CenterForOpenScience/developer.osf.io). and then check the Relevant are files `osf-docs/swagger-spec/preprints/list.yaml` and `osf-docs/swagger-spec/preprints/definition.yaml`. A well documented test-case can be found [here](https://raw.githubusercontent.com/CenterForOpenScience/osf-selenium-tests/develop/api/osf_api.py) which can start as a good launch-off point.

## Zenodo API

In Elixir BioHackathon 2022, we had written a Guile program to deposit artifacts via the Zenodo API. We tested this against the sandbox server they provide for testing. This year, in Elixir BioHackathon 2023, we ported this code to Ruby (see supplement below) to better integrate with our existing Ruby codebase.

## Future work

For future work, one feature request is to include support for converting graphs to images for PDF generation. This can be achieved with [mermaid](https://github.com/mwiget/pandoc-mermaid) in pandoc, for example. At this point we do not opt to include mermaid because it depends on a headless chromium browser --- that is not something we like to run in a web service environment.
An alternative may [D2](https://github.com/terrastruct/d2), a modern diagram scripting language that turns text to diagrams. D2 recently got a free software license.

Another improvement may be adding optional support for an E-mail address so the submitter can be contacted. Most biohackathon authors are easy to find on the internet, by virtue of their public contributions in the free software community. Even so, for a publication it may be useful to have a single contact.

We also discussed support for papers submitted in other languages. We think that is a good idea and pandoc+tetex should support internationalisation (i8n). For a next biohackathon such a proof-of-concept appears to be in order.
Another feature we would like to introduce is to support org-mode as an alternative for markdown. Pandoc can already transform one to the other.

At this biohackathon we did not explore APIs of wikidata, PubMed, UniProt and others relevant to BioHackrXiv publications. In the near future, before implementing the full workflow, we will also need to look at [software heritage archive](https://www.softwareheritage.org/) because one of the goals is to store software output and data as part of a working groups outcome. The goal of the Software Heritage initiative is to collect all publicly available software in source code form together with its development history, replicate it massively to ensure its preservation, and share it with everyone who needs it. It provides an API and on upload exposes a permanent identifier. It is therefore not necessary to store software in Zenodo that is contributed to Software Heritage.

Of the mentioned services in this paper: Wikidata, PubMed, UniProt, Software Heritage Archive, EuropePMC and Zenodo appear to be long term initiatives that we can build on for BioHackrXiv. Building our own submission system will give us new options for presenting BioHackrXiv and for improving the workflow and experience for both submitters and readers of BioHackrXiv.

# Repositories

The web server repositories are hosted on https://github.com/biohackrxiv/. The pandoc and LaTeX templates for PDF generation are at https://github.com/biohackrxiv/bhxiv-gen-pdf. The preview generation web service is at https://github.com/biohackrxiv/preview.biohackrxiv.org.

# Acknowledgements

We thank the organisers of the ELIXIR BioHackathon 2023 for the event and hosting the BioHackrXiv working group. We also thank DBCLS for sponsoring the OSF.io hosting of BioHackrXiv and we thank initiatives, such as OSF, Zenodo and others that provide these great long lasting APIs.

# Supplemental listing

Ruby script for accessing the Zenodo API and depositing a ZIP file:

\scriptsize

```ruby
require 'json'
require 'net/http'

zenodo_endpoint = URI("https://sandbox.zenodo.org")
access_token = File.read(ARGV[0])
artifact = ARGV[1]
metadata = JSON.parse(File.read(ARGV[2]))

def zenodo_uri(endpoint, path, access_token)
  uri = URI.join(endpoint, path)
  uri.query = URI.encode_www_form({:access_token => access_token})
  uri
end

def zenodo_deposit(endpoint, access_token, artifact, metadata)
  http = Net::HTTP.new(endpoint.host, endpoint.port)
  http.use_ssl = true
  http.start() do |http|
    # Create a deposition with some metadata.
    request = Net::HTTP::Post.new("/api/deposit/depositions?access_token=" + access_token,
                                  initheader = {"Content-Type" => "application/json"})
    request.body = {:metadata => metadata}.to_json
    links = JSON.parse(http.request(request).body)["links"]
    bucket = URI(links["bucket"])
    publish = URI(links["publish"])

    # Upload file.
    request = Net::HTTP::Put.new(bucket.request_uri + "/" + artifact + "?access_token=" + access_token,
                                 initheader={"Content-Type" => "application/octet-stream"})
    request.body = File.read(artifact)
    http.request(request)

    # Publish.
    request = Net::HTTP::Post.new(publish.request_uri + "?access_token=" + access_token)
    JSON.parse(http.request(request).body)
  end
end

print zenodo_deposit(zenodo_endpoint, access_token, artifact, metadata)
```

# References
