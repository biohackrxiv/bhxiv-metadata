---
title: 'Data validation and schema interoperability'
title_short: 'Data validation and schema interoperability'
tags:
  - schema
  - data validation
  - interoperability
  - FAIR
authors:
  - name: Leyla Garcia
    orcid: 0000-0003-3986-0510
    affiliation: 1
  - name: Jerven Bolleman
    orcid: 0000-0002-7449-1266
    affiliation: 2
  - name: Michel Dumontier
    orcid: 0000-0003-4727-9435
    affiliation: 3
  - name: Simon Jupp
    orcid: 0000-0002-0643-3144
    affiliation: 4
  - name: Jose Emilio Labra Gayo
    orcid: 0000-0001-8907-5348
    affiliation: 5
  - name: Thomas Liener
    orcid: 0000-0003-3257-9937
    affiliation: 6
  - name: Tazro Ohta
    orcid: 0000-0003-3777-5945
    affiliation: 7
  - name: Núria Queralt-Rosinach
    orcid: 0000-0003-0169-8159
    affiliation: 8
  - name: Chunlei Wu
    orcid: 0000-0002-2629-6124
    affiliation: 9
affiliations:
 - name: ZB MED Information centre for life sciences, Gleueler Str. 60, 50931 Cologne, Germany
   index: 1
 - name: Swiss Institute of Bioinformatics, Quartier Sorge - Batiment Amphipole, 1015 Lausanne, Switzerland
   index: 2
 - name: Maastricht University, Minderbroedersberg 4-6, 6211 LK Maastricht, The Netherlands
   index: 3
 - name: European bioinformatics institute EMBL-EBI, Wellcome Genome Campus, CB10 1SD, Hinxton, United Kingdom
   index: 4
 - name: Universidad de Oviedo, C/Federico García Lorca, S/N, CP 33007, Oviedo, Spain
   index: 5
 - name: Thomas Liener Consultancy, www.linkedin.com/in/thomas-liener
   index: 6
 - name: Database Center for Life Science, Joint Support-Center for Data Science Research, Research Organization of Information and Systems, Yata 1111, Mishima, Shizuoka, Japan
   index: 7
 - name: Harvard Medical School, Countway Library 10 Shattuck St, Boston, MA 02115, United States
   index: 8
 - name: The Scripps Research Institute, 10550 N Torrey Pines Rd, La Jolla, CA 92037, United States
   index: 9
date: 20 December 2019
bibliography: paper.bib
authors_short: Leyla Garcia & Jerven Bolleman \emph{et al.}
group: Schemas Working Group
---

# Background

Validating RDF data becomes necessary in order to ensure data compliance against the conceptualization model it follows, e.g., schema or ontology behind the data. Validation could also help with data consistency and completeness. There are different approaches to validate RDF data. For instance, JSON schema is particularly useful for data expressed in JSON-LD RDF serialization while Shape Expression (ShEx)[@baker_shape_2019] and Shapes Constraint Language (SHACL) [@knublauch_shapes_2017] can be used with other serialization as well. Currently, no validation approach is prevalent regarding others, depending on data characteristics and personal preferences one or the other can be used. In some cases, the approaches are interchangeable; however, that is not always the case, making it necessary to identify a subset among them that can be seamlessly translated from one to another.

During the NBDC/DBCLS BioHackathon 2019, we worked on a variety of topics related to RDF data validation, including (i) development of ShEx shapes for a number of datasets, (ii) development of a tool to semi-automatically create ShEx shapes, (iii) improvements to the RDFShape tool [@labra-gayo_rdfshape:_2018] and (iv) enabling validation schema conversion from one format to the other. In the following sections we detailed the work done on each front.

# Hackathon results

## Development of ShEx shapes

We created and updated ShEx shapes for different biomedical resources including Health Care Life Science (HCLS) dataset descriptions [@gray_dataset_2015], Bioschemas [@gray_bioschemas:_2017],
and DisGeNET [@pinero_disgenet:_2017]. In order to make it easier for future updates, we developed some applications to automatically create ShEx shapes from HCLS datasets specification and Bioschemas profiles.

### Bioschemas

Schema.org is a collaborative effort aiminingto create, mantain and promote schemas for strutcture data on the Internet [@schema_org_noauthor_home_nodate]. Bioschemas is a community-driven project aiming to support schema.org types for Life Sciences. It contributes to the community by adding life Science types to schema.org, defining profiles adjusted to community needs, and developing supporting tools. A Bioschemas profile is a type customization including property cardinality and requirement level. Bioschemas shapes currently focus on profiles corresponding to the Biotea project, particularly those related to bibliographic data. Biotea [@garcia_biotea:_2018] provides a model to express scholarly articles in RDF, including not only bibliographic data but also article structure and named entities recognized in the text.

Biotea-Bioschemas ShEx shapes are created via a Jupyter notebook from the YAML Bioschemas profile files. Schema.org datatypes are transformed to XML Schema Definition (XSD) while supporting shapes are created for any combination of schema.org types used as ranges. In addition, three main shapes are created for any Bioschemas profile, corresponding to the three property requirement levels, i.e., minimum, recommended and optional. Profile information, i.e., profile name, schema.org type and YAML file location, are encoded in a comma separated value (CSV) file, making it easy to use the code to generate shapes for any other Bioschemas profile. More information is available at the GitHub repository for this project [@garcia_biotea/validation-shapes-bioschemas_2019].

### DisGeNET

DisGeNET is a comprehensive gene-disease association knowledge base in the Life Sciences. It is widely used by the biomedical community and its Linked Data representation has been selected as an Elixir Europe [@noauthor_elixir_nodate] interoperability resource.  However, it is still lacking a way to easily query this vast amount of information and explore this knowledge across other domains through its SPARQL endpoint.

During the BioHackathon we implemented the DisGeNET-RDF ShEx shape [@rosinach_nuriaqueralt/shex-shapes_2019]. In order to do so, we used RDFShape [@web_semantics_group_at_university_of_oviedo_rdfshape_nodate] and the suite of generation and validation tools it comes with.  We detected some disagreements between the DisGeNET schema illustrated on its website and the actual underlying data.  We actively discussed around how to best tackle the development of the ShEx shapes in an automatic and data-driven way so we can continue working on it after the BioHackathon.

### HCLS

The HCLS Community Profile for Dataset Descriptions offers a concrete guideline to specify dataset metadata as RDF including elements of data description, versioning, and provenance so as to support discovery, exchange, query, and retrieval of dataset metadata. As part of their work, the HCLS Community created Validata [@beveridge_validata:_2015], a web application to check the compliance of RDF documents to the guideline specifications. Validata used a non-standard extension of ShEx to check various compliance levels.

We created a ShEx compliant document by processing the HCLS guideline using a PHP script [@dumontier_micheldumontier/hcls-shex_2019]. The result is several ShEx documents that can be used to check compliance at various levels (MUST, SHOULD, MAY, SHOULD NOT, MUST NOT). We validated our work against the exemplar documents that are provided as part of the guideline, and have also used it to detect errors in HCLS metadata from UniProt. Our work revealed errors in UniProt metadata and the RDFShape tool.

### Rare disease catalogs and registries

Data on rare disease is currently fragmented across various databases and online resources making efficient and timely use of this data in rare disease research challenging. Several data catalogs exist that collect data from biobanks and patient registries but these data are neither comprehensive or readily interoperable across catalogs.  There is now an international effort to improve the discovery, linkage and sharing of rare disease data through the development of standards and the adoption of FAIR data principles. One component of this process is the development of common metadata models for describing and sharing data across resources using standard vocabularies and ontologies.

During the hackathon we explored the use of both JSON schema and ShEx for validating data that conforms to schemas developed as part of the European Joint Programme on Rare Diseases (EJP RD) [@noauthor_ejp_nodate]. The EJP RD schemas are expressed using JSON Schema, and are accompanied by an additional JSON-LD context file that enables instance JSON data from data providers to be transformed into RDF. At the hackathon we developed a set of new ShEx shapes that could validate the resulting RDF. This required mapping validation rules, such as required properties and cardinality/value type constraints, from JSON schema to an equivalent constraint in ShEx. We were able to demonstrate how more complex types of validation were also possible using ShEx when additional RDF based resources are available. For example, we can express that the `dcat:theme` of rare disease dataset must be a URI and that this URI should be any subclass of the root disease class in the Orphanet rare disease ontology.  The resulting EJP RD schemas and accompanying ShEx files are all available on GitHub [@jupp_ejp-rd-vpresource-metadata-schema_2019].

## ShEx creator

While ShEx is very useful as demonstrated to validate RDF data, the syntax to actually write a ShEx expression can be hard for new users and is time-consuming also for experienced people. Therefore, a prototype of a ShEx creator was proposed for the BioHackathon. This tool should help users to write correct ShEx expressions faster. The prototype is implemented as a javascript tool, supporting the user through e.g. dropdown menus to create a correct ShEx structure and it uses the RDFShape API in the background to validate the created ShEx expression. The prototype can be found at the corresponding GitHub repository [@liener_lltommy/rdfvalidation4humans_2019].

## Improvements to RDFShape tool

The RDFShape tool [@labra-gayo_rdfshape:_2018] comprises a set of tools to create and validate RDF data via ShEx and SHACL shapes. During the BioHackathon, it was used to create shapes and validate RDF data from different endpoints. Thanks to it, we identified some improvements for this tool such as the possibility to validate triples obtained from a mix including RDF data provided by the user and data already contained in a SPARQL endpoint. This feature was added to the new version developed during the BioHackathon.

We also explored and implemented new visualization features for ShEx. Our implementation resulted in the  separation in several modules:
- RDFShape client [@noauthor_weso/rdfshape-client_2019] which consists of a javascript client based on the React framework.
- RDFShape server [@noauthor_weso/rdfshape_2019] contains the server part and is implemented in Scala using the http4s [@noauthor_http4s_nodate] library.
- umlSHaclEx] [@noauthor_weso/umlshaclex_2019] is a module that generates UML-like visualizations from Shapes schemas. The library can be used as a standalone command line tool.
- SHaclEX [@noauthor_weso/shaclex_2019] contains the main validation modules for ShEx and SHACL.
- SRDF [@noauthor_weso/srdf_2019] defines a simple RDF interface with the main features required by the validation library. The module contains several implementations of that interface which enables the use of validation with Apache Jena [@noauthor_apache_nodate] models, RDF4j [@guindon_eclipse_nodate], or SPARQL endpoints.

## Schema conversion across validation approaches

As part of our work, during the BioHackathon we worked on identifying a common subset of ShEx that could be used as the basis for the generation of RDF data models documentation, which can later be converted to JSON schema, ShEx or SHACL. Although full interoperability between those languages is not feasible, we consider that a subset language could be defined that could handle the most common cases [@Labra-Gayo2019].

Through CD2H's [@noauthor_cd2h_nodate] Data Discovery Engine [@noauthor_ctsa_nodate] project, we previously developed a web-based tool called Schema Playground [@noauthor_ctsa_nodate-1] to facilitate the schema visualization, hosting and extension. It helps developers to publish their existing schemas as well as build new schemas by extending the existing ones. Schema Playground currently supports schema.org schemas defined in JSON-LD format and JSON-schema-based data validation. While JSON-schema is a good-fit for the underlying JSON-based data structure, ShEx and SHACL provide a more expressive way to describe validation rules when the underlying data are presented as triples. At the hackathon, we converted several JSON-Schema based validation rules to ShEx and performed the validation on the underlying data (e.g., dataset metadata). These exercises help us to identify the requirements to add support for ShEx in our BioThings schema playground.

# Conclusion

We developed a formal description of the HCLS dataset metadata guidelines in a manner that is compliant with the latest version of ShEx. This work is important not only to the HCLS community that uses the guideline, but also can form a basis for automated computational validation of metadata descriptions, as per the FAIR (Findable, Accessible, Interoperable, Reusable) principles. In a similar vein, we prototyped a ShEx shapes (semi)automatic solution for Bioschemas which could be later extended to Bioschemas profiles other than those defined by Biotea. We also developed a prototype corresponding to the first formal description of the DisGeNET-RDF data model by using ShEx [@rosinach_nuriaqueralt/shex-shapes_2019]. Our strategy to generate the DisGeNET-RDF ShEx shape comprised three steps: (i) manual building via the depicted schema on the web, then (ii) polishing via inference from some actual data instances, and (iii) validating against all the database via the SPARQL endpoint. The shapes created for DisGeNET will work as a basis to develop a more automated solution for this resource.

The development of ShEx shapes using the RDFShape tools resulted in a user testing exercise, where bugs were identified. This direct interaction with users allowed us quickly implement fixes and immediately testing them with users, giving place to a new version. In addition, from the creation of ShEx shapes and the transformation from one format to another, we identified a need to improve tools and technologies used to describe and validate RDF data. Such validation could facilitate machine-readable community agreements regarding metadata, thus leading to more Findable, Accessible, Interoperable and Reusable (FAIR) data as community-based validators could interoperate with the FAIR metrics evaluator [@wilkinson_evaluating_2018].

# Future work

Regarding the generation of ShEx shapes, HCLS team plans to check the compliance of other HCLS dataset metadata documents on the web and report to the community our findings while Bioschemas will work on a validation platform that can later communicate with the FAIR evaluator. Regarding DisGeNET, the ShEx shapes will be finalized and move to a more automatic generation.

In order to overcome the necessity to learn yet another syntax, i.e., ShEx syntax, the work on ShEx tooling will continue. Currently, the ShEx creator is a rough prototype. Future work consists of (i) making the code more stable and potentially publish it as npm module and  (ii) integrate the ShEx creator within the RDFShape tool website, so it could further be combined with existing functionality, e.g., ShEx visualization in RDFShape platform.

RDFShape will continue using user feedback to improve the services provided, taking into account scalability requirements of big SPARQL endpoints. Several issues appeared when validating those big data portals, such as the need to improve error messages, and to handle streaming validation for big RDF data. Regarding the visualization, we will work an a direction similar to the one carried out by the Japanese Life Science Database Integration portal [@noauthor_home_nodate]. This portal uses data model representations drawn manually, combining instances and schemas. In such a way, they can show a visualization that users will follow more easily as they will observe real data rather than only the underlying model. Future work could extend the visualization capabilities of RDFShape to automatically generate those kind of visualizations. Other future works on the RDFShape platform include the development of Jupyter notebooks integrating and showcasing the different tools provided.

The BioThings team also plan to continue their work after the hackathon to allow publishing and visualizing ShEx schemas in Schema Playground, along with the support of schemas defined in schema.org and JSON-schema format. The ShEx parsing tools developed at RDFShape will be adopted to convert input ShEx schema into its JSON format for indexing purpose. And the visualization tool from RDFShape can also be used to generate the graph-representation of a ShEx schema.

# Jupyter notebooks created
* Bioschemas ShEx shapes: https://github.com/biotea/validation-shapes-bioschemas

# Acknowledgements
This work was done during the BioHackathon 2019 organized by NBDC/DBCLS in September 2019 in Fukuoka, Japan. We thank the organizers for the opportunity and the support via travel grants for some of the authors.

# References
