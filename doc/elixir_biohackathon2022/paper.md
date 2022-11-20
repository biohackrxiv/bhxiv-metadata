---
title: 'Metadata handling for biohackathon publications through BioHackrXiv'
title_short: 'Metadata handling for biohackathon publications through BioHackrXiv'
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
authors_short: Mats Perk, Arun Isaac et al.
---

# Introduction

In this paper we present the work executed on BioHackrXiv during the international Elixir Biohackathon in Paris, France, 2022.
[BioHackrXiv](https://biohackrxiv.org/) is a scholarly publication service for
biohackathons and codefests that target biology and the biomedical sciences in the spirit of pre-publishing platforms [@citesAsRecommendedReading:preprints].
Over thirty papers have been published through this system and with the amount of biohackathons and codefests increasing every year, we expect this type of reporting and publishing to continue.
The goal was to further improve deployment and take-up of the web service and to set a road map for improving the workflow and explore integration of EuropePMC [@citesAsAuthority:EuropePMC], OpenCitation
[@citesAsRecommendedReading:Shotton2018; @citesAsAuthority:Shotton2013]
and [Zenodo](https://zenodo.org/) services.

BioHackrXiv publications are generated from simple powerful markdown/LaTeX templates where the header is a YAML/JSON record that includes the title, authors, affiliations and tags. The idea originated from the [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) layout that is used in the Journal of Open Source Software (JOSS)[@citesAsAuthority:JOSS].
Templates are provided as an [example](https://github.com/biohackrxiv/publication-template).

As described in the BioHackrXiv Elixir 2020 Biohackathon paper (in preparation), metadata is crucial to publications, including acquiring a digital object identifier (DOI). DOIs are permanent URIs to PDFs, so publications can be cited by others. One interesting aspect is that DOIs support versioning - that means papers can be updated under the same DOI, this is not the case with content-addressable identifiers, such as the Interplanetary File System (IPFS).

In the existing workflow we host BioHackrXiv.org as a -- so called -- pre-print service with the Open Science Foundation (OSF.io). OSF manages the publication submission system and creates a DOI on acceptance. A DOI may look like \url{https://doi.org/10.37044/osf.io/km9ux} and should resolve to a hosted PDF.
Another important identifier is ORCID for authors [@citesAsRecommendedReading:EuropePMC].

For the authors, the current setup, demands writing a paper in a git repository using [pandoc flavoured markdown](https://garrettgman.github.io/rmarkdown/authoring_pandoc_markdown.html) that allows for embedded LaTeX. We wrote a preview web service at \url{http://preview.biohackrxiv.org/} that generates a nice looking PDF from a pasted git URL, or alternatively a zipped up file containing paper.md and paper.bib. Next, the main author has to submit the paper through the OSF managed pre-print system.
After a cursory check, one of the editors of BioHackrXiv will accept or reject the paper -- mostly as a curation step against SPAM. After acceptance the paper appears online with a DOI and automatically gets included in the EU PMID or EuropePMID, followed by OpenCitations.

Even though the system works as a `minimal viable product', and the PDF generation and submission works rather well, we identified a number of problems with the existing workflow:

1. Authors have to submit some information twice because OSF does not parse the metadata header of the paper - particularly author name and institute - which is prone to mistakes (missing authors, misspellings).
1. For the same reason ORCIDs are not propagated from the metadata headers in the paper submission
1. The current submission page does not track the git repository where the publication is hosted. Often the editor has to ask for that separately
1. In previous biohackathons we engineered a metadata graph that exports publications and their authors. Updating this graph includes some manual steps and that causes significant delays in updating the graph to show our aggregated output page at http://preview.biohackrxiv.org/list. That page should show a list of publications and their authors and it has a JSON version at http://preview.biohackrxiv.org/list.json
1. When authors choose to submit a zip file we have to contact the authors for all relevant metadata
1. The current system can not include accompanying code and data with the submission
1. The preview service has a limitation of one paper per git repository --- this often confuses authors

We identified these challenges and decided we need to automate more and work on the mechanism of submitting and generating publications and their metadata. In this biohackathon, in addition to fixing bugs and helping other groups format their biohackathon publications, we visited OSF, Zenodo, and OpenCitations APIs and RDF, wrote proof-of-concept code, and this resulted in a new road map for BioHackrXiv.

# Results

## OSF API

BioHackrXiv uses OSF as a web service to manage the workflow for PDF submission, editorial review, DOI generation, PDF view and basic search. There are a number of limitations (see introduction) and during this biohackathon we explored if we can use the OSF API to create our own submission system.

One of the cool aspects of OSF is that its web UI services use their own REST API to create the functionalities. This means that we, in theory, can use the REST API to roll our own.

According to the documentation it is possible to create & upload PDFs via the API in /v2/preprints,
as described [here](https://developer.osf.io/#operation/preprints_create).
The docs can be found [here](https://github.com/CenterForOpenScience/developer.osf.io). and then check the Relevant are files `osf-docs/swagger-spec/preprints/list.yaml` and `osf-docs/swagger-spec/preprints/definition.yaml`.
A well documented test-case can be found [here](https://raw.githubusercontent.com/CenterForOpenScience/osf-selenium-tests/develop/api/osf_api.py) which can start as a good launch-off point.

## EuropePMC

EuropePMC gets its metadata from OSF and contains all papers published on BioHackrXiv, after a little delay.

Interestingly EuropePMC exposes RDF from REST API. E.g. the query
 https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=doi:10.37044/osf.io/8qdse&format=dc

Results in something like


\scriptsize

```xml
<rdf:RDF>
  <rdf:Description rdf:about="http://europepmc.org/abstract/PPR/PPR281949">
    <dc:title>Data validation and schema interoperability</dc:title>
    <dc:creator>Garcia Castro, LJ</dc:creator>
    <dc:creator>Bolleman, J</dc:creator>
    (...)
    <dc:description>Preprint</dc:description>
    <dc:date>2020-04-07</dc:date>
    <dc:identifier>http://europepmc.org/abstract/PPR/PPR281949</dc:identifier>
    <dc:identifier>https://doi.org/10.37044/osf.io/8qdse</dc:identifier>
    <dcterms:bibliographicCitation>
      Garcia Castro LJ, Bolleman J, dumontier m, Jupp S, Labra-Gayo JE,
      Liener T, Ohta T, Queralt-Rosinach N, Wu C.
      Data validation and schema interoperability BioHackrXiv;2020.
      .doi:10.37044/osf.io/8qdse. PPR:PPR281949.
    </dcterms:bibliographicCitation>
    <dcterms:bibliographicCitation/>
    <dcterms:abstract>
      Validating RDF data becomes necessary in order to ensure data
      compliance against the conceptualization model it follows, e.g., ...
  </dcterms:abstract>
  </rdf:Description>
</rdf:RDF>
```

\normalsize

All this information is derived from the OSF API, including misspellings of authors (notice one author is not capitalised) and missing authors on second time of entry. This reentering of author data should be taken out of the existing submission workflow.
Also the ORCIDs that are collected in the publication do not appear in this data, perhaps because the submission page of OSF.io does not collect them. EuropePMC provides a separate tool/API to link authors with their publications
[@citesAsAuthority:EuropePMC].

So, the main issue is:

1. Missing metadata and wrong metadata from EuropePMC even though the metadata in the paper header is correct.

Interesting URLs we collected that the [EuropePMC REST API](https://europepmc.org/RestfulWebService) provides:

* [XML output](https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=doi:10.37044/osf.io/8qdse&format=xml)
* [JSON output](https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=doi:10.37044/osf.io/8qdse&format=json)
* [RDF](https://www.ebi.ac.uk/europepmc/webservices/rest/search?query=doi:10.37044/osf.io/8qdse&format=dc)

## OpenCitations

* Contains papers that cite each other
* Uncited papers not included
* Data fetched from EuropePMC.org
* Includes DOI
* Includes misspelled authors
* Supports ORCID
* Takes time to sync
* OpenCitations also provides a REST API

The following is the example query used in https://opencitations.net/index/sparql

\scriptsize

```SQL
PREFIX cito:<http://purl.org/spar/cito/>

SELECT DISTINCT ?citing_entity ?cited_entity ?creation_date ?timespan
WHERE {
	GRAPH <https://w3id.org/oc/index/coci/> {
		?citation a cito:Citation ;
			cito:hasCitingEntity ?citing_entity ;
			cito:hasCitationCreationDate ?creation_date ;
			cito:hasCitationTimeSpan ?timespan ;
			cito:hasCitedEntity ?cited_entity
	}
} LIMIT 10
```

\normalsize

testing with curl

\scriptsize

```sh
curl -v --data-urlencode query@examplerq.rq \
  https://opencitations.net/index/sparql
```

\normalsize

results in a list of

\scriptsize

```xml
<result>
     <binding name='citing_entity'>
 		<uri>http://dx.doi.org/10.1007/978-3-319-92979-8_1</uri>
 	</binding>
 	<binding name='cited_entity'>
 		<uri>http://dx.doi.org/10.1002/gj.2736</uri>
 	</binding>
 	<binding name='creation_date'>
 		<literal datatype='http://www.w3.org/2001/XMLSchema#date'>
          2018-06-12</literal>
 	</binding>
 	<binding name='timespan'>
 		<literal datatype='http://www.w3.org/2001/XMLSchema#duration'>
          P2Y6M5D</literal>
 	</binding>
</result>
```

\normalsize

According to this [BLOG](https://opencitations.hypotheses.org/958) OpenCitations supports ORCID. In fact it looks it up for authors that miss such information. FIXME: test

## Zenodo API

We wrote a Guile program to test the Zenodo API (see supplement below). Zenodo has a special test infrastructure that you can test the API. Only problem was that they kicked us off after the first data upload! After contacting support it took a week to open up the sandbox testing environment for us, i.e., after the BioHackathon.

## Virtuoso as a system container

BioHackrXiv uses RDF to track metadata on publications, parsed directly from the markdown documents that are submitted. The preview web server, for example, queries the graph and caches the result in memory. The main RDF store and SPARQL endpoint runs in virtuoso-ose and for this biohackathon we decided to create a GNU Guix system container - that allows easy deployment of the full service anywhere. The definition is [here](https://github.com/genenetwork/genenetwork-machines/commit/3cebfb3e30e903851aefb2f997d8847d3f0ddee4) with the public SPARQL endpoint https://sparql.genenetwork.org/sparql

## Enhancements

During the week we added or improved:

* Unit tests
* CITO (cite)
* LaTeX support
* Template support

As such, a new template is provided with
[examples](https://github.com/biohackrxiv/publication-template) of figures, tables and bibliography.

# Discussion

BioHackrXiv allow projects to publish their work as a citeable resource in the form of non-peer reviewed pre-published papers [@citesAsRecommendedReading:preprints]. A minority of these may end up as a peer reviewed paper. Even so, getting citeable resources is valuable and work done at biohackathons does not get lost this way. These non-peer reviewed publications:

1. Help working groups capture and expose their work for future reference
1. Help authors gain a track record and citations as they automatically get included in EuropePMID and google citations [@citesAsRecommendedReading:preprints]. Support for PMID may come in the future as JOSS is working on that, see this [tracker](https://github.com/openjournals/joss/issues/153).
1. Help organisers of biohackathons and codefests justify their work and budget

In this Elixir biohackathon 2022 over 200 people contributed to 40 working groups and we expect to capture much of that effort in BioHackrXiv publications. Having no peer review for BioHackrXiv publications lowers the barrier to entry and, even though, papers may not be perfect in terms of language or grammar, we find the information content to be high and the quality to reflect the work people are executing in their projects. For a list of publications ordered by biohackathon, see [this](http://preview.biohackrxiv.org/list).

We received many positive comments on the usefulness of BioHackrXiv and a commitment to include more biohackathons. Our workflow supports handing out accounts to biohackathon organisers, so they themselves can handle the 'editor' curation of papers coming in from their event.

BioHackrXiv itself also participated as group 4 in the Elixir Biohackathon 2022 and this resulted in the work presented in this paper. Apart from fixing bugs and improving functionality, such as LaTeX table support and adding CITO terms, we explored the APIs of OpenCitations, EuropePMC, Zenodo and OSF.

OpenCitations present a RDF graph of papers that get cited by other papers. This is a very useful resource because it allows back tracing the graph to relevant papers. We will embed OpenCitations in a web UI for authors, working groups to explore publications that references their publication.

EuropePMC is the European version of Pubmed and allows referencing on non-peer reviewed publications, such as bioarxiv [@citesAsRecommendedReading:preprints] and BioHackrXiv.
Zenodo is a European initiative built on the CERN data warehousing facilities to create DOIs on resources, such as software and data. It allows up to 50Gb of storage per user for free.

## Road map

Based on above explorations of APIs we believe we can create our own workflow for paper submissions on top of the OSF-API. In the next step we can opt for Zenodo to store the accompanying source code and data to create one or more citeable DOIs. Zenodo allows storing up to 50Gb of data per person --- in this case the uploading author --- which should be good enough for most projects.

We have defined a road map which can greatly improve the user experience of BioHackrXiv.org. Creating our own front-end and workflow will free us to lower the barrier to entry even more for publishing group efforts in a citeable paper. In time we can provide the option of storing code+data with the PDF. Even later we may be able to explore running reproducible environments using that code and data using the type of continuous integration systems that are available through github, for example.

EuropePMC gets its data from OSF and that leads to incomplete and wrong metadata. The solution is to write our own uploader that can push to OSF and/or Zenodo to get an API. Advantage: choice for DOI generation. No double input for author name and institute. Automatic inclusion of ORCIDs and other metadata.

The itemised road map in a feasible order might be:

1. Replace BioHackrXiv front page with our own and use the OSF API to submit the PDF making the process easier and avoiding duplication of entering author names etc. We can keep using the OSF editorial workflow initially.
1. Validate the metadata on EuropePMC and OpenCitations through comparison with our RDF back-end
1. Replace OSF editorial workflow so we can more easily support editorial delegation to biohackathon organisers.

Another aspect may be internationalisation of the front-ends.

The justification for this work is that there may be hundreds of biohackathons in the coming years and, supposing we have a suitable setup, it may be manageable to get thousands of publications. Furthermore, the code base and approach for this web service may lead to other initiatives for hosting similar reports/publications.

## Future work

For future work, one feature request is to include support for converting graphs to images for PDF generation. This can be achieved with [mermaid](https://github.com/mwiget/pandoc-mermaid) in pandoc, for example. At this point we do not opt to include mermaid because it depends on a headless chromium browser --- that is not something we like to run in a web service environment.

Another improvement may be adding optional support for an E-mail address so the submitter can be contacted. Most biohackathon authors are easy to find on the internet, by virtue of their public contributions in the free software community. Even so, for a publication it may be useful to have a single contact.

We also discussed support for papers submitted in other languages. We think that is a good idea and pandoc+tetex should support internationalisation (i8n). For a next biohackathon such a proof-of-concept appears to be in order.
Another feature we would like to introduce is to support org-mode as an alternative for markdown. Pandoc can already transform one to the other.

At this biohackathon we did not explore APIs of wikidata, Pubmed, Uniprot and others relevant to BioHackrXiv publications. In the near future, before implementing the full workflow, we will also need to look at [software heritage archive](https://www.softwareheritage.org/) because one of the goals is to store software output and data as part of a working groups outcome. The goal of the Software Heritage initiative is to collect all publicly available software in source code form together with its development history, replicate it massively to ensure its preservation, and share it with everyone who needs it. It provides an API and on upload exposes a permanent identifier. It is therefore not necessary to store software in Zenodo that is contributed to Software Heritage.

Of the mentioned services in this paper: Wikidata, Pubmed, Uniprot, Software Heritage Archive, EuropePMC and Zenodo appear to be long term initiatives that we can build on for BioHackrXiv. Building our own submission system will give us new options for presenting BioHackrXiv and for improving the workflow and experience for both submitters and readers of BioHackrXiv.

# Repositories

We invite contributions to parsing and adding relevant metadata to
BioHackrXiv RDF. Simply do a pull request on
https://github.com/biohackrxiv/bhxiv-metadata. The web server repositories
are hosted on https://github.com/biohackrxiv/.

# Acknowledgements

We thank the organisers of the Elixir BioHackathon 2022 for the event and hosting the BioHackrXiv working group.
We also thank DBCLS for sponsoring the OSF.io hosting of BioHackrXiv and we thank the great initiatives, such as OSF, Zenodo, OpenCitations, EuropePMC and others that provide these great long lasting APIs.

# Supplemental listing

Guile Scheme script for accessing the Zenodo API and submitting a zip file, code written by Arun Isaac:

\scriptsize

```scheme
(use-modules (rnrs io ports)
             (srfi srfi-26)
             (srfi srfi-71)
             (ice-9 match)
             (web client)
             (web response)
             (web uri)
             (json))

(define %zenodo-api-endpoint
  (string->uri "https://sandbox.zenodo.org/api"))

;; Register on the sandbox zenodo server at
;; https://sandbox.zenodo.org/, create an access token at
;; https://sandbox.zenodo.org/account/settings/applications/tokens/new/,
;; and put in a file "access-token".
(define %zenodo-access-token
  (call-with-input-file "access-token"
    get-string-all))

(define %file-to-upload
  "foo.zip")

(define %metadata
  '(("title" . "My first upload")
    ("upload_type" . "poster")
    ("description" . "This is my first upload.")
    ("creators" . #((("name" . "Doe, John")
                     ("affiliation" . "Zenodo"))))))

(define (json-ref scm . keys)
  (match keys
    ((key other-keys ...)
     (apply json-ref
            ((if (list? scm) assoc-ref vector-ref) scm key)
            other-keys))
    (() scm)))

(define* (zenodo-request method uri #:key body json)
  (let ((uri (build-uri (uri-scheme (if (uri? uri)
                                        uri
                                        %zenodo-api-endpoint))
                        #:host (uri-host (if (uri? uri)
                                             uri
                                             %zenodo-api-endpoint))
                        #:port (uri-port (if (uri? uri)
                                             uri
                                             %zenodo-api-endpoint))
                        #:path (if (uri? uri)
                                   (uri-path uri)
                                   (string-append (uri-path %zenodo-api-endpoint) (uri-path uri)))
                        #:query (string-append "access_token=" %zenodo-access-token))))
    (format (current-error-port) "~a ~a~%" method (uri->string uri))
    (let ((response port (http-request uri
                                       #:method method
                                       #:body (if json
                                                  (scm->json-string json)
                                                  body)
                                       #:headers (if json
                                                     '((content-type application/json))
                                                     '())
                                       #:streaming? #t)))
      (let ((json (json->scm port)))
        (unless (= (quotient (response-code response) 100)
                   2)
          (error "Request failed with response" response json))
        json))))

(define zenodo-get
  (cut zenodo-request 'GET <...>))

(define zenodo-post
  (cut zenodo-request 'POST <...>))

(define zenodo-put
  (cut zenodo-request 'PUT <...>))

(let ((json
       ;; Create a deposition with some metadata.
       (zenodo-post (string->uri-reference "/deposit/depositions")
                    #:json `(("metadata" . ,%metadata)))))
  ;; Upload file
  (zenodo-put (string->uri (string-append (json-ref json "links" "bucket")
                                          "/" %file-to-upload))
              #:body (call-with-input-file %file-to-upload
                       get-bytevector-all))
  ;; Publish.
  (zenodo-post (string->uri (json-ref json "links" "publish"))))
```


# References
