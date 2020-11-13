---
title: 'Comparison of SARS-CoV-2 variants with INSaFLU and galaxyproject'
tags:
  - COVID-19
  - galaxyproject
  - INSaFLU
  - SARS-CoV-2
  - variant calling
  - workflow
  - Covid-19 Virtual BioHackathon 2020
authors:
  - name: Nazli Sila Kara
    affiliation: 1
  - name: Meltem Kutnu
    affiliation: 2
  - name: Yasemin Utkueri
    affiliation: 3
  - name: Funda Yilmaz
    affiliation: 4
  - name: Elif Bozlak
    affiliation: 5,6
  - name: Evrim Fer
    affiliation: 7
affiliations:
  - name: Department of Medical Biochemistry, Faculty of Medicine, Istinye University, Istanbul,Turkey
    index: 1
  - name: Department of Biological Sciences, Middle East Technical University, Ankara, Turkey
    index: 2
  - name: Faculty of Engineering and Natural Sciences, Sabanci University, Istanbul, Turkey
    index: 3
  - name: Radboud University, Donders Centre for Cognition, Nijmegen, 6525 HR, The Netherlands
    index: 4
  - name: Institute of Animal Breeding and Genetics, University of Veterinary Medicine Vienna,Vienna, 1210, Austria
    index: 5
  - name: Vienna Graduate School of Population Genetics, Vienna, Austria
    index: 6
  - name: Department of Genetics, University of Arizona, Tucson, USA
    index: 7
date: 19 April 2020
bibliography: paper.bib
---

# Introduction

Covid-19 Virtual BioHackathon 2020 hosts many ongoing projects on workflows about either for the development of the existing ones or combining two or more of them for better functioning.Some of these workflows are Galaxy Project, INSaFLU and nf-core. In these pipelines, the inputs are genome sequence reads mostly coming from Illumina but also Oxford Nanopore, which are analyzed through these workflows by branching whether it is single end or paired end, as output, the annotated variant lists including single nucleotide polymorphisms (SNPs) and small insertion deletion (indel) are provided. We compared published variants by Galaxy project with produced variants by INSaFLU workflow in the course of our study.

\begin{itemize}
\item galaxyproject/SARS-CoV-2

Galaxy, a scientific community and open-source platform, provides workflows, datasets and histories enabling accessibility, reproducibility, and transparency in computational biology, mostly for genomic research [@nekrutenko2020no]. In Galaxy Projects, there are many workflows including genomic sequence assembly, variant calling, In this study, we used galaxyproject/SARS-CoV-2 workflow proposed by Galaxy community and this workflow will be named as “Galaxy workflow” in the latter part of this report. Steps of Galaxy workflow for variant analysis include mapping with BWA (for paired end data) or bowtie2 (for single end data), filtering steps, variant calling with lofreq and annotation with SnpEff, to choose a variant calling algorithm for the workflow, they compared FreeBayes, Mutec2 and lofreq, and based on the results, they used lofreq in the workflow.

\item INSaFLU

INSaFLU has been originally developed as a web-based platform for influenza-based bioinformatics analysis and authors suggest that it can be also used for rapid assessment of variants for the novel coronavirus SARS-CoV-2 [@borges2018insaflu]. In order to determine variant positions, it uses bwa for mapping, samtools and FreeBayes algorithms for variant calling and SnpEff for variant annotation. The INSaFLU interface provides many features which are gene and whole-genome consensus sequences, phylogenetic trees, as well as gene, protein and genome alignments. Besides, it shares annotated variant files.
\end{itemize}

Taking into account the impact of the differences in analysis steps of different workflows [@baichoo2018developing],our
project for Covid-19 Virtual BioHackathon 2020 aimed to compare variants determined by the INSaFLU workflow for the same samples that have been analyzed with the Galaxy workflow between 20.03.2020 and 02.04.2020. For this purpose, the Illumina reads were retrieved from the SRA database, then all samples were uploaded to the INSaFLU interface and workflow was run with updated reference genome NC045512.2. The resulting variants were used to detect the shared and unique variants in two different workflows. In the final step, some general properties of the variants were analyzed.

# Results 

## Variant Detection by INSaFLU and Comparison with Galaxy

In the first place, we wanted to have a variant list for the INSaFLU workflow to compare with published variant files from Galaxy. To run the INSaFLU workflow, we uploaded fastq files obtained from SRA by SRA toolkit. Although we tried to use all of the samples that were already analyzed in the Galaxy workflow, it was not possible to upload some of the samples because of technical limitations. Due to the lack of time, limited storage, computer pace and internet connection capacities, we used the web interface of INSaFLU workflow [@borges2018insaflu] which allows the upload of files smaller than 300 Mb. Because of the file size limitation, we could not try all samples with INSaFLU, while the large size samples have been analyzed in Galaxy workflow. Despite the file size limitation, we were able to upload 50 samples (Supplementary Table 1) to INSaFLU and an INSaFLU was run with these samples. The updated reference genome for COVID-19 (NC045512.2) was used in INSaFLU analyses. The workflow was run with these samples and the reference genome. In the end of the run, we obtained 2 result files, which were validated variants and minor intra-host SNVs (variants below 50% frequency) in .tsv format. The second technical limitation that we faced in INSaFLU was losing some of the samples because of a coverage error. In the lost samples, the percentages of locus size covered by at least 1-fold and by at least 10-fold were less than 100%.The coverage of these samples did not allow the detection of variants [@borges2018insaflu]. Despite these technical difficulties, we had a sufficient number of samples (see figure \ref{fig1}) and variants (see figure \ref{fig2}) at the end of the INSaFLU run and we were able to compare the variants from the remaining samples with the Galaxy workflow output.

![Number of samples used in the workflows. Samples that are used in the INSaFLU workflow were chosen from published variant files at Galaxy. \label{fig1}](./table1.png)

Comparison of the samples from both pipelines gave results for 24 samples (see figure \ref{fig2}). Therefore, we continued with these 24 samples to compare found variants. We detected 597 “shared” variations for these 24 samples from the algorithms besides the unique ones, which were 321 in INSaFLU and 2256 in Galaxy (see figure \ref{fig2}). The uniquely found variants in the Galaxy workflow is almost 7 times more than the uniquely found variants by INSaFLU. The reason for that could be the higher sensitivity of the lofreq [@wilm2012lofreq] algorithm which is designed for microbial sequences used in Galaxy. Besides, the different number of total variants detected in different workflows could also be explained by different mapping and filtering parameters used in these workflows. When we looked at the distribution of the shared and unique variants among 24 samples (see figure \ref{fig2}), surprisingly we saw that many of the unique variants in the Galaxy workflow are coming from a few samples (SRR11059942, SRR11059944, SRR11059945), whereas INSaFLU did not detect as many. These samples and their sequence data could be analyzed in detail to find out the reason for such a high amount of unique variants in further studies. Besides, for some samples such as SRR11059940, SRR11059943 and SRR11241255, INSaFLU detected more unique variants than Galaxy. In all samples except SRR11454612, INSaFLU and Galaxy detected shared variants. Variants subjected to Figure 2b were given in the supplementary as four different .tsv files (galaxy_shared.tsv, galaxy_unique.tsv, insaflu_shared.tsv, insaflu_unique.tsv) by adding all of the samples analyzed in Galaxy and INSaFLU in which the same variants were detected. In the insaflu_unique.tsv and insaflu_shared.tsv files, the variants were given as they were annotated in the INSaFLU results, while the galaxy_unique.tsv and galaxy_shared.tsv files include the annotations from the Galaxy results. These files include more than 24 samples because we aimed to take all of the samples in the database which carry the target variants.

![ a) Venn diagram showing the number of shared and unique variants identified by INSaFLU and Galaxy workflows. b) Bar plot showing the number of shared and unique variants detected by Galaxy and INSaFLU workflows per sample. Red shows shared variants, blue shows INSaFLU-specific variants and green shows Galaxy-specific variants. Number of variants for each condition is given as a function of logarithm in base 2. \label{fig2}](./table2.png)

## Properties and frequencies of variants detected in the samples

By using files that we created in the previous step, we compared detected variants coming from Galaxy and INSaFLU to see different mutation types and abundances of shared variants in the all sequenced samples.

First, we compared the variation types (synonymous and non-synonymous) of all variants. The Number of different variation types in 4 different files that we created is given in Figure 3. Although the same variants are defined in different workflows, they were annotated differently in their results. This gives rise to a difference in the number of variant classes for shared variants. Overall, the amount of non-synonymous mutations are greater than the synonymous ones. Among the non-synonymous variants, 275 missense variants were found in the replicase polyprotein 1ab, and 67 missense variants were found in the spike glycoprotein. Several missense variations were also found in ORF’s 7a and 7b, ORF8, ORF3, ORF10, ORF3a, M (membrane protein coding sequence) and in the nucleoprotein sequence.

The protein coding sequences of two proteins, replicase polyprotein 1ab and Spike, have the highest number of non-synonymous variants. When we have a closer look at these proteins, we see that replicase polyprotein is involved in viral RNA replication and transcription [@wu2020new], whereas Spike glycoprotein is a mediator for the attachment of virus to human ACE2 receptor [@zhou2020network]. Variations on the coding sequences of these proteins can be further investigated.

![Bar plot showing the number of synonymous and non-synonymous variants identified by Galaxy and INSaFLU. Galaxy variants are green, INSaFLU variants are blue. Numbers are given as a function of logarithm in base 2 \label{fig3}](./table3.png)

When we analyzed the reference and alternative allelic states of the shared variants (597), we found that almost half of the (282) variants were multiallelic, whereas 270 variants were biallelic among samples and workflows. This again shows how different workflows create differences in the results. We also found different reference alleles coming from different workflows for the same variants in 45 variants. The possible reason for that is using the updated reference (NC045512.2) for the INSaFLU analysis. When we look at the abundances of shared biallelic variants (detected by both algorithms) among all samples, we see that while some variants are unique for individual samples (Supplementary Table 2), some are more frequent among all samples (see figure \ref{fig4}). We conclude that higher frequency variants which are detected by both workflows in same properties and in many samples are potential segregating sites in the population.

![Distribution of biallelic variants seen in more than 5 samples. X-axis shows the variants names in a combination of chromosome and position and Y-axis shows the number of samples which carry the variants. \label{fig4}](./table4.png)

# Conclusion

During the week of Covid-19 Virtual BioHackathon 2020, we compared two different workflows; GalaxyProject and INSaFLU to evaluate their performances in terms of variant calling. We wanted to see whether INSaFLU could identify the same variants with GalaxyProject or not. As a result, we could detect shared variants as well as many unique variants in both workflows. We then analyzed mutation types and their abundances among samples.

Two main issues we have encountered from INSaFLU during our analysis were the limited file upload size and sample coverage. Some of the samples with an exceeding file size could not be uploaded to INSaFLU. Moreover, coverage of numerous assembled reads were found to be low after running the program. Therefore, we were compelled to continue with samples that have higher coverage. 

We next identified shared and unique variants for both Galaxy and INSaFLU. We could observe 597 shared variants, with almost 50% of them occurring within the coding sequence of replicase polyprotein 1ab. While categorizing shared variants as either non-synonymous or synonymous, we observed that annotations of some variants were given differently (see figure \ref{fig3}). Additionally, we looked at the allelic properties of the variants, and observed that almost half of them were multiallelic. Distinct reference alleles which come from Galaxy and INSaFLU workflows were present for the same variants. The reason for this could be further investigated. Some of the shared variants were found to be more frequent, hinting to potentially segregating alleles.

Based on our results, we conclude that using multiple workflows can be advantageous to eliminate some of wrong variants as well as identifying true candidates that could be missed [@hwang2019comparative]. The shared and unique variants that we shared in the subject of the study would be considered in this aspect for further studies.

# Future Work

The comparison of variants from different workflows can be enriched by adding another workflow to further validate the variant results. The nf-core/viralrecon workflow [@ewels2020nf] is one of the strong candidates for such aim, which performs low frequency variant analysis and SNP annotation. The resulting variants from our study could also be compared with the already published variants from different studies such as NextStrain [@hadfield2018nextstrain] to see their accuracy. In addition, mutation patterns and types of mutations in shared files could be investigated.

As a result of possible effects of non-synonymous mutations on protein structures and functions, the non-synonymous variants would be interesting to analyze in further studies. These variants could be analyzed in detail to see their possible phenotypic effects on the virus pathogenicity or virus-host interaction. Moreover, it could be highly beneficial to model the effects of non-synonymous mutations at protein structure level. Conformational changes within protein structures resulting from such variants could be illustrated via protein modeling and possible functional changes could be further examined. Modeling of proteins which take part in host infection and host-virus interaction could be useful, since computer aided drug design techniques enable modeling and synthesis of antiviral drugs that could have inhibitory effects on such proteins  [@klimenko2017computer]. These drugs could be utilized to block host-virus interaction or viral replication pathways and further contribute to decrease the levels of viral infection on the host.

# GitHub Repository

The repository contains the supplementary material [https://github.com/rsgturkeygroup3/BioHackathon]

# Acknowledgements

We would like to express our very great appreciation to the organization team of Covid-19 Virtual BioHackathon 2020 for enabling us to take part in the help for COVID-19 pandemic. Also special thanks to RSG Turkey representatives for their assistance.

# References
