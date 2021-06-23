---
title: 'Knowledge graphs and wikidata subsetting'
title_short: 'Knowledge graphs and wikidata subsetting'
tags:
  - Wikidata
  - ShEx
  - RDF
  - Knowledge graphs
authors:
  - name: Jose Emilio Labra Gayo
    orcid: 0000-0001-8907-5348
    affiliation: 1
  - name: Ammar Ammar
    affiliation: 2
  - name: Dan Brickley
    affiliation: 3
  - name: Daniel Fernández Álvarez
    affiliation: 1
  - name: Alejandro González Hevia
    orcid: 0000−0003−1394−5073
    affiliation: 1
  - name: Alasdair J G Gray
    orcid: 0000-0002-5711-4872
    affiliation: 4
  - name: Eric Prud'hommeaux
    orcid: 0000-0003-1775-9921
    affiliation: 5
  - name: Denise Slenter
    affiliation: 2
  - name: Harold Solbrig
    affiliation: 6
  - name: Seyed Amir Hosseini Beghaeiraveri
    affiliation: 4
  - name: Benno Fünkfstük
    affiliation: 8
  - name: Andra Waagmeester
    affiliation: 7
  - name: Egon Willighagen
    affiliation: 2
  - name: Liza Ovchinnikova
    affiliation: 3
  - name: Guillermo Benjaminsen
    affiliation: 3
  - name: Roberto García
    orcid: 0000-0003-2207-9605
    affiliation: 9
  - name: Leyla Jael Castro
    affiliation: 10    
  - name: Daniel Mietchen
    affiliation: 11
    
affiliations:
  - name: WESO research group, University of Oviedo, Spain
    index: 1
  - name: Maastricht University
    index: 2
  - name: Google, London, UK
    index: 3
  - name: Heriot-Watt University, UK
    index: 4
  - name: Janeiro Digital, W3C/MIT
    index: 5
  - name: Johns Hopkins University
    index: 6
  - name: Micelio/Gene Wiki
    index: 7
  - name: TU Dresden
    index: 8
  - name: Universitat de Lleida, Spain
    index: 9
  - name: ZB MED Information Centre for Life Sciences, Germany
    index: 10    
  - name: University of Virginia, USA
    index: 11    
date: 14 January 2021
bibliography: paper.bib
event: BH20EU
group: Wikidata subsetting
authors_short: Jose E. Labra \emph{et al.}
---

<!-- You can comment/uncomment the following if you want or not the table of contents...
[TOC]-->

<!--

The paper.md, bibtex and figure file can be found in this repo:

  https://github.com/kg-subsetting/preprint-biohackrxiv

-->



# Abstract 

<!-- I removed references from the abstract...I like abstract which are text-only. We can add references in the introduction and the rest of the paper... -->

Knowledge graphs have successfully been adopted by academia, governement and industry to represent large scale knowledge bases. 
Open and collaborative knowledge graphs such as Wikidata capture knowledge from different domains and harmonize them under a common format, making it easier for researchers to access the data while also supporting Open Science.

Wikidata keeps getting bigger and better, which subsumes integration use cases. Having a large amount of data such as the one presented in a scopeless Wikidata offers some advantages, e.g., unique access point and common format, but also poses some challenges, e.g., performance.
Regular wikidata users are not unfamiliar with running into frequent timeouts of submitted queries. Due to its popularity, limits have been imposed to allow for fair access to many.
However this suppreses many interesting and complex queries that require more computational power and resources. Replicating Wikidata on one's own infrastructure can be a solution which also offers a snapshot of the contents of wikidata at some given point in time. 

There is no need to replicate Wikidata in full, it is possible to work with subsets targeting, for instance, a particular domain. Creating those subsets has emerged as an alternative to reduce the amount and spectrum of data offered by Wikidata. Less data makes more complex queries possible while still keeping the compatibility with the whole Wikidata as the model is kept. 
 
In this paper we report the tasks done as part of a Wikidata subsetting project during the Virtual BioHackathon Europe 2020 and SWAT4(HC)LS 2021, which had already started at NBDC/DBCLS BioHackathon 2019 in Japan, SWAT4(HC)LS hackathon 2019, and Virtual COVID-19 BioHackathon 2019. We describe some of approaches we identified to create subsets and some susbsets from the Life Sciences domain as well as other use cases we also discussed. 


# Introduction

<!--
>> [name="Labra"] Short motivation (use cases will be in a separate section later)
-->

There are several benefits and use cases derived from extracting knowledge graphs subsets. 
For example, it is possible to extract datasets for a specific research task from a given knowledge graph with multiple data. 
It also allows users to store these subsets locally and reduce database scaling and costs. 
The extracted subsets can be a useful resource for researchers which can analyze the evolution of the data and develop on-the-fly transformations and subsets for their specific needs.

During the last years there were multiple BioHackathon efforts to develop mechanisms which extract subsets from linked data. 
One example would be the [G2G language](https://github.com/elixir-europe/BioHackathon-projects-2019/blob/master/projects/28/src/g2g/wikidata_disease.g2g) created in a 2019 BioHackathon Europe project, which used a mixture of SPARQL expressions and Cypher patterns to extract property graphs. 

<!-- 
> [name="Labra"] The reference to G2G is a bit ugly...it points to just an example of the G2G...I though about including a reference to the [github repo](https://github.com/elixir-europe/BioHackathon-projects-2019/tree/master/projects/28) but it doesn't mention the G2G language...do we have a better reference to cite?
-->

An initial effort started during BioHackathon 2019 and SWAT4(HC)LS 2019 to define the topical use cases and main methods which were collected as [informal notes](https://docs.google.com/document/d/1MmrpEQ9O7xA6frNk6gceu_IbQrUiEYGI9vcQjDvTL9c/edit#heading=h.7xg3cywpkgfq) that were later added to a [Wikidata project](https://www.wikidata.org/wiki/Wikidata:WikiProject_Schemas/Subsetting). 
Later, at the virtual Covid-19 BioHackathon in April, an initial prototype was started to use ShEx schemas to define the subsets to be extracted from a wikibase instance.

This report collects the main advances developed during the virtual [BioHackathon 2020](https://www.biohackathon-europe.org/), [project 35](https://github.com/elixir-europe/BioHackathon-projects-2020/tree/master/projects/35) which were complemented with the [SWAT4HCLS virtual hackathon](https://swat4hcls.wiki.opencura.com/wiki/Main_Page) in January 2021.

# Description of activities

In this section we report the different activities that were done during the BioHackathon Europe 2020 and the SWAT4HCLS hackathons at the beginning of 2021. 

## General overview

<!-- 
> [name="Labra"] 
> TODO: Add a better version of the diagram
![Diagram presenting the different approaches \label{fig}](./schema.png)
-->

As a running example we departed from the GeneWiki [@tsueng_gene_2016] project following [@Waagmeester2020]. That paper includes a figure with a UML-like data model representing the main concepts related with life sciences in the GeneWiki project. That figure was taken as the initial point with the goal of obtaining a WikiData subset that followed the data model represented in that figure.

<!-- 
> [name=Labra] I am not sure if we can add a copy of that figure here or just refer to it...should we ask the publishers? --> It depends on the license
-->

We classify the activities in 4 parts:
- Describing the subsets: how do we describe what subset of wikidata we are interested in? 
- Extraction techniques: which approach can we follow to extract the subset from wikidata?
- Publishing and using the subset: once we have the subset, how do we publish it so it can be used?
- Use cases: what use cases did we identify? 


## Describing the subsets

A first step to obtain a Knowledge Graph subset is to describe what we expect to extract. Given that we are talking about really big data, this process must be done in a machine-processable way. Also, given that those subsets are intended to be used by people, they should be easily described by some domain experts. 

A common use case is to define the boundaries of the subset by some topic identifying the type of entities or properties that are of interest for a given use case. Next, it is necessary to describe the bounderies of that subset in its larger context of all of Wikidata.

We identified several approaches to describe subsets:
- SPARQL Construct queries
- Filtering by rule patterns
- Shape Expressions and entity schemas
- Defining a domain specific language

### SPARQL construct queries

<!--
> [name=Labra]
> We could use a running example which would help readers to follow the paper better. I chose "anatomical_structures" because it was the first one I had at hand...maybe a better one is better?
> [name=Gray]
> I agree a running example would be useful. We could also include the English statement of the example in the opening of the section, or the use cases if they are moved before this section.
-->

One approach to extract data from any SPARQL endpoint is to use SPARQL construct queries. As an example, the [following query] (https://github.com/ingmrb/WikidataSubsetting/blob/main/Public%20queries%20method/SPARQL%20queries/Wiki%20types/anatomical_structure.sparql) can be used to retrieve anatomical structures from Wikidata.

```sparql=
CONSTRUCT {
  ?anatomical_structure wdt:P31 wd:Q4936952.
  ?anatomical_structure wdt:P361 ?part_of.
  ?anatomical_structure wdt:P527 ?has_part.
} WHERE {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952
} UNION {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952. 
  ?anatomical_structure wdt:P361 ?part_of.
} UNION {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952. 
  ?anatomical_structure wdt:P527 ?has_part.
}
```

SPARQL construct queries can also transform the data retrieved on-the-fly. For example, the previous query could be expressed to transform it into using terms from the [schema.org vocabulary](https://schema.org/)  ([original query](https://github.com/ingmrb/WikidataSubsetting/blob/main/Public%20queries%20method/SPARQL%20queries/Schemas/anatomical_structure.sparql)).

```sparql=
CONSTRUCT {
  ?anatomical_structure a schema:AnatomicalStructure.
  ?anatomical_structure schema:partOfSystem ?part_of.
  ?anatomical_structure schema:subStructure ?has_part.
} WHERE {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952
} UNION {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952. 
  ?anatomical_structure wdt:P361 ?part_of.
} UNION {
  ?anatomical_structure wdt:P31/wdt:P279* wd:Q4936952. 
  ?anatomical_structure wdt:P527 ?has_part.
}
```

### Filtering by rule patterns

[WDumper](https://wdumps.toolforge.org/) is a tool created by Benno Fünkfstük that generates Wikidata RDF dumps on demand. 
The tool is based on [Wikidata Toolkit](https://github.com/Wikidata/Wikidata-Toolkit) and allows the user to select the desired entities and properties according to rule patterns, as well as other settings like labels, descriptions, aliases, sitelinks, etc. 
Upon request the service creates the RDF dumps which can later be downloaded. 

Internally, the rules are represented by a JSON configuration file. 
The rules are patterns that identify either an intended entity or property and retrieve all content that is related with them. 
An example of a rule that obtains all entities that are instances of `wd:Q4936952` (anatomical structure) could be:

```json
{
    "version": 1,
    "__name": "anatomical_structure",
    "entities": [
      {
        "id": 3,
        "type": "item",
        "properties": [
          {
            "id": 4,
            "type": "entityid",
            "rank": "all",
            "value": "Q4936952",
            "property": ""
          }
        ]
      }
    ],
    "meta": true,
    "aliases": true,
    "sitelinks": true,
    "descriptions": true,
    "labels": true,
    "statements": [
      {
        "id": 5,
        "qualifiers": false,
        "simple": true,
        "rank": "all",
        "full": false,
        "references": false
      }
    ]
  },
  . . .
```

The JSON configuration file contains several properties related with the wikidata data model so it is possible to declare if we also want to retrieve qualifiers, ranks, etc.

<!-- 
> [name="labra"] In the previous sentence I mention the wikidata data model...review if we say something about it earlier...
> [name="Gray"] The model has not been introduced. However, none of the previous text has required the detail. If later text needs it then we should have a section eariler that gives an overview of the Wikidata model.  
> The other question would be are we only considering Wikidata for subsetting? What about DBpedia or KGs in general? I appreciate that WDumper only works for Wikidata, but its approach could be implemented for other KGs.
> [name="labra"] Indeed that's a very good question. In principle, the ShEx+slurper approach can work with any RDF-based knowledge graph, but it is true that in the biohackathon we focused mainly on Wikidata.
-->

### ShEx and entity schemas

ShEx was created in 2014 as a human-readable and concise language for RDF validation and description [@EricSemantics2014]. 
In 2019, ShEx was adopted by Wikidata to define entity schemas [@Thornton2019] and there is already a [directory of entity schemas](https://www.wikidata.org/wiki/Wikidata:Database_reports/EntitySchema_directory) which have been collaboratively defined by the community.

During the BioHackathon Europe 2020 we defined a ShEx schema based on the GeneWiki data model. The full ShEx schema is [here](https://github.com/kg-subsetting/biohackathon2020/blob/main/use_cases/genewiki/genewiki.shex). Using RDFShape, it is also possible to have [UML-like visualizations](http://rdfshape.weso.es/link/16076069146) of the ShEx schemas. As an example, the shape of `anatomical_structure` is:

```shex
:anatomical_structure EXTRA wdt:P31 {
  wdt:P31  [ wd:Q4936952 ] ;
  wdt:P361 @:anatomical_structure * ; 
  wdt:P527 @:anatomical_structure *
}
```

ShEx validators can use a technique called "slurp", which consists of keeping track of the triples that they have visited during validation. 
With this technique it is possible to obtain Wikidata subsets directly from the ShEx schemas.

In some cases, manually creating a ShEx data model may detract the users which just want to obtain a subset which is similar to some example data. 
[sheXer](http://shexer.weso.es/)  is a tool that automatically extracts ShEx schemas from instance data which can be used in this case. 


### Wikidata subsetting language

During the BioHackathon, we considered that it was possible that ShEx was too expressive and it contained constructs that were not necessary for just creating Wikidata subsets. 
As an example the shape:

```shex
:anatomical_structure EXTRA wdt:P31 {
  wdt:P31  [ wd:Q4936952 ] ;
  wdt:P361 @:anatomical_structure * ; 
  wdt:P527 @:anatomical_structure *
}
```

As a possible alternative we considered a configuration like:

```json
 { "anatomical_structure":
     { "on-type": "wd:Q4936952",
      "wdt:P361": "anatomical_structure", 
      "wdt:P527": "anatomical_structure" },
       "wikidata-specific-magic-extras": "..."
    {  // etc.
    }
}
```

Given a JSON file like the above, a processor could generate SPARQL construct queries or WDumper JSON configuration files.

The team considered that further work could be done in this direction in the future.


## Extraction of subsets from Wikidata

### Using Shape Expressions and Slurp

During validation, ShEx processors can keep track of the triples used for the validation process and create an RDF dump with them, which will follow the ShEx schema. 
As an example, given the ShEx schema of anatomical structure. We may start the validation by using the following ShapeMap:

```shex
{FOCUS wdt:P31 wd:wd:Q4936952}@:anatomical_structure
```

which means that we will validate all nodes that have property `wdt:P31` with value `wd:Q4936952` (anatomical_structure). 
The validator would find candidate nodes to validate like: 

```
wd:Q1074 (skin)
wd:Q7891 (respiratory system)
... 
wd:Q168291 (cornea)
wd:Q169342 (retina)

. . .
```

Notice that the shape indicates that anatomical structures can be part of other anatomical structures using property `wdt:P361`. 
When the ShEx validator validates the cornea node, it will find the triple `wd:Q168291 wdt:P361 wd:Q7364`, collect it, and continue validating the `wd:Q7364` node. This graph traversal process allows to collect an RDF dump which is based on the nodes that are really linked by the graph.

The following example uses a Wikidata ShEx definition to construct a minimal conforming graph from Wikidata using PyShEx slurper. It has been deployed as a 
[Jupyter notebook](https://github.com/hsolbrig/PyShEx/blob/master/notebooks/WikiSlurper.ipynb).

During the BioHackathon we detected 2 issues:

- The Wikidata's SPARQL endpoint uses blank nodes.
- The slurp process can generate too many requests to Wikidata's endpoint.

> Talk about issue with blank nodes and endpoints...
> Phabricator ticket: https://phabricator.wikimedia.org/T267782
> 2 appearances of blank nodes: 
> - to represent ontological constructs like `owl:complementOf` which may be justified.
> - to express unknown and no values. This use could be replaced
> TODO: Extend this explanation?


### WDumper

<!--
> [name=Labra]
> We could describe the process followed by WDumper if we have more information/details about it
> `@@Guillermo` could describe here how he combined the SPARQL construct queries with WDumper
-->

WDumper can extract information from a complete Wikidata dump at once. This dump must be in the Wikidata JSON format. Wikidata JSON dumps are published weekly under this [Wikimedia dumps page](https://dumps.wikimedia.org/wikidatawiki/entities/). The extractor part of WDumper uses the Wikidata Toolkit Java library to scroll the JSON dump and extract entities based on the filters specified by the specification file.

The JSON Wikidata dump file is actually a single array of Wikidata entities. For each entity, the related information like labels, descriptions, and claims are stored in different sub-arrays (see the [Wikibase JSON data model](https://doc.wikimedia.org/Wikibase/master/php/md_docs_topics_json.html) for more information). In its navigation, WDumper selects any entity that matched in the filters, and for each selected entity, it extracts labels, descriptions, claims, etc. based on the specification file. Finally, WDumper builds an RDF structure of the extracted data using the Wikidata namespace and returns the final data into a compressed N-Triple format. It takes approximately 10 hours for WDumper to build a subset from the current Wikidata full dump.

- WDumper + SPARQL Construct Queries to extract data from wikidata, which was done in [https://github.com/ingmrb/WikidataSubsetting](this repo)
- Scrapping and linking data from web data portals which contain bioschemas metadata like [mobidb](https://mobidb.bio.unipd.it/) and [disprot](https://disprot.org/). This step was done in [https://github.com/elizusha/scraper](this repo).
- Creating a Wikibase instance from RDF dumps with a script and [WikidataIntegrator](https://github.com/SuLab/WikidataIntegrator)
- 
<!-- 
> [name=Labra]
> I think `@@Guillermo` uses a combination of WDumper + SPARQL construct queries...confirm...
> [name=Labra] 
> Talk here about the process to link the extracted contents to other contents...for example, in our running example, they linked it to scrapped data from mobidb and disprot
> `@@Liza` could add here some description of the scrapping
> github repo: 
> [name=Labra]
> Talk about 
> - Wikibase
> - WikidataIntegrator: 
> - I think Andra created a script and a docker image linking everything with WikidataIntegrator...
-->

## Publishing and using the subsets

During the BioHackathon 2020 the main focus of the team was to create a Wikidata subsetting. 
After the BioHackathon, a team lead by Dan Brickley created a [docker image](http://185.78.196.96:8889/bigdata/#splash) of a Wikidata subset based on GeneWiki which at the same time contained triples that have been scrapped from [mobidb](https://mobidb.org/) and [disprot](https://www.disprot.org/). 
In this way, during SWAT4(HC)LS hackathon the team focused on how those wikidata subsets could be used and published.

### Documenting the subset

We have employed ShEx schemas to document the extracted subset as well as [sheXer](http://shexer.weso.es/) to automatically extract the shapes.

<!-- 
> [name=Labra]
> - Extracting the ShEx schema using sheXer
> 
-->

### RDF HDT

<!--
> [name=Labra]
> Talk about RDF HDT dumps...we had a long discussion at SWAT4(HC)LS in which Lydia, Javier Fernández and Wouter Beek participated...
-->

All data generated by the WDumper from the Blazegraph Docker image (gcr.io/wikidata-collab-1/full_graph) was extracted ans is available at https://rhizomik.net/html/~roberto/swat4hcls as separate Turtle files and an HDT file that combines all them.

We also published the RDF HDT file using Fuseki through a SPARQL endpoint, which is available as a Docker image, [fuseki-hdt-docker](https://github.com/rogargon/fuseki-hdt-docker).

1. Download HDT file:
```shell
curl -L -o combined.hdt \
https://rhizomik.net/html/~roberto/swat4hcls/combined.hdt
```

2. Deploy [fuseki-hdt-docker](https://github.com/rogargon/fuseki-hdt-docker) to serve the HDT file using SPARQL

```shell
docker run -d -p 3030:3030 \
-v $(pwd)/life-combined.hdt:/opt/fuseki/dataset.hdt:ro \
--name fuseki-hdt rogargon/fuseki-hdt-docker
```

3. Consume the data through Fuseki's SPARQL endpoint at `http://localhost:3030/dataset/sparql`. You could use a ny SPARQL client or send queries directly using `curl`:

```shell
curl -X POST localhost:3030/dataset/sparql \
     -d "query=SELECT DISTINCT ?class (COUNT(?i) AS ?count) WHERE { ?i a ?class } GROUP BY ?class ORDER BY DESC(?count)" 
```

### Interactive visualizations/explorations

Rhizomer is a web application for interactive exploration of semantic and linked data available from SPARQL endpoints. With Rhizomer, lay users can explore datasets performing the 3 data analysis tasks:

- **Overview**: get the full picture of the data set at hand 
    - Rhizomer generates a wordcloud to provide an overview of the kinds of things in the dataset. Future work is to generate other overview components like site map, site index or treemap.

- **Zoom & Filter**: zoom in on items of interest and filter out uninteresting items
    - Once a class is selected, Rhizomer generates a faceted view. It zooms in and allows filtering resources of the chosen type based on their properties. Future work is to also allow pivoting among classes through facets.

- **Details**: after zooming and filtering the user arrives at the resources of interest
    - All properties and values are shown for every selected resource. It is also possible to browse linked resources. Future works it to include visualisations like maps or timelines.

<!-- ![](https://i.imgur.com/K8MjZkj.png) -->

Rhizomer is available as two Docker containers; one for the frontend and another for the backend. More details about how to deploy Rhizomer are available from https://github.com/rhizomik/rhizomerEye

### SPARQL queries and demos

We also developed several SPARQL queries that demoed the resulting dataset with some information provided in this [repo](https://github.com/athalhammer/danker-hdt-docker).

<!-- 
> [name=Labra]
> We talked about providing nice SPARQL queries and/or demos about the subset we obtained...In this section it would be nice to at least describe one very nice SPARQL query showing what we accomplished...ideas?
> - Description of https://github.com/athalhammer/danker-hdt-docker by athalhammer ?
-->

# Use cases

We identified several use cases where knowledge graphs subsetting could be interesting like the Gene Wiki, Scholia, Chemistry and fact-checking.

<!-- 
## GeneWiki

> [name=Labra]
> This use case is probably part of the running example along the whole paper...so we may remove it from here and title the section "Other use cases"

## Scholia

> [name=Labra]
> I think this use case comes mainly from Ammar

## Chemistry

> [name=Labra]
> This use case comes from Denise



## Fact-checking

> [name=Labra]
> We talked a bit about this use case and it think it makes sense...maybe add some prose or a real use case?
-->

## Other activities

Given that the BioHackathon Europe 2020 and SWAT4(HC)LS 2021 were virtual events, the team missed the opportunity of more personal interaction but gained the possibility of inviting external contributors to collaborate in our activities. In this way we did the following activites:
- Meeting with ShExCG. Given that the [W3C ShEx Community group] meets regularly every 2 weeks on wednesday and that the event overlapped with the BioHackathon, on 11th november 2020, the ShExCG was invited to participate in the BioHackathon and we presented our work to the ShExCG.
- Joint meeting with Alasdair Gray, Ivan Micetic and Petro Papadopoulos from [the Bioschemas project](https://github.com/elixir-europe/BioHackathon-projects-2020/tree/master/projects/24) to talk about the interaction with the creation of wikidata subsettings and the mappings to external data annotated using bioschemas vocabulary.
- Meeting with Benno Funkstük, creator of WDumper to talk about the possibilities and limits of the tool.
- Meeting with Lydia Pintscher, from Wikidata, to talk about the creation of Wikidata dumps using RDF HDT.
- Meeting with Javier Fernández and Wouter Beek to talk about RDF HDT

<!-- 
> [name=Labra] I really like this: https://twitter.com/andrawaag/status/1350063285287215106
> so I adapted it for the paper, should we quote it?
-->

As Dan Brickley pointed out during the event, "The nice thing about virtual events over real events is that it allows instantly reaching out to expertise needed, and for experts on the matter join. We had several guests that would be almost impossible at a face to face event.". See [https://twitter.com/andrawaag/status/1350063285287215106](https://twitter.com/andrawaag/status/1350063285287215106).

<!-- 
# Discussion

> [name=Labra] 
> TODO...if we don't have nothing to say, we could merge this section with the conclusions section...
> - A link with the resulting docker image?
> - Future work: Wikidata subsetting as a service?


# Conclusions

> [name=Labra]
> 

[TOC]
-->

# References
