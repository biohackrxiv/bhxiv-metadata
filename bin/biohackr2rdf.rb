#! /usr/bin/env ruby
#
# Use this script to generate the RDF TTL file

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'erb'
require 'fileutils'

OUTPUT="test/data/biohackrxiv.ttl"

RDF_HEADER = <<HEADER
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix bhx: <http://biohackerxiv.org/resource/> .
@prefix schema: <https://schema.org/> .

HEADER

rdf_event_template = <<ETEMPLATE
<<%= url %>> schema:description "<%= descr %>"@en ;
    schema:name "<%= name %>" ;
    dc:date "<%= date %>"^^xsd:date ;
    a schema:Event .
ETEMPLATE

rdf_paper_template = <<PTEMPLATE
<<%= id %>> dc:title "<%= title %>"@en ;
    schema:sameAs <<%= doi %>> ;
    schema:url <<%= url %>> ;
    bhx:Event <<%= event %>> ;
    dc:date "<%= date_published %>"^^xsd:date ;
    a schema:CreativeWork .

<% authors.each do | author | %>
<<%= id %>> dc:contributor "<%= author['name'] %>" .
<% end %>
<% tags.each do | tag | %>
<<%= id %>> bhx:Tag "<%= tag %>"@en .
<% end %>
PTEMPLATE

print "BioHackrXiv metadata generator...\n"

events = YAML.load_file('etc/events.yaml')['events']
papers = YAML.load_file('etc/papers.yaml')['papers']

File.open(OUTPUT, 'w') do |file|
  file.print(RDF_HEADER)
  pp events
  events.each do | name, data |
    p data
    url = data['url']
    descr = data['txt']
    date = data['date']
    renderer = ERB.new(rdf_event_template)
    file.print(output = renderer.result(binding))
  end
  file.print("\n")
  papers.each do |paper|
    pp paper
    url = paper['url']
    id = paper['id']
    doi = paper['doi']
    date_published = paper['date_published']
    if url and url != 'unknown'
      print "Fetching '#{url}'...\n"
      uri = URI.parse(url)
      begin
        data = Net::HTTP.get(uri)
      rescue Errno::ECONNREFUSED
        raise "Could not fetch #{url} for #{id}"
      end
      # fetch markdown
      md = ""
      data.split("\n").each { |line|
        break if line =~ /^$/
        md += line+"\n" if md != "---"
      }
      print("Metadata: ",md)

      info = YAML.load(md).merge(paper) # note that contents of paper override md
      pp info
      title = info['title']
      id = info['id']
      authors = info['authors']
      tags = info['tags']
      eventid = info['event']
      raise "Uknown event for #{id} - please update ./etc/papers.yaml" if not eventid
      event = events[eventid]['url']
      raise "Missing event for #{id}" if !event
      renderer = ERB.new(rdf_paper_template)
      file.print(output = renderer.result(binding))
      # cache file
      dir = "papers/"+eventid
      FileUtils.mkdir_p dir
      fn = dir + "/" + title + ".md"
      File.open(fn, 'w') { |file| file.write(data) }
    else
      if not url
        raise "Undefined paper.md URL for #{id} - please update ./etc/papers.yaml"
      end
    end
  end
end

print "Wrote RDF to #{OUTPUT}\n"
print "You may want to validate with: rapper -i turtle test/data/biohackrxiv.ttl\n"
print "Update graph with: curl -X PUT --digest -u dba:dba -H Content-Type:text/turtle -T test/data/biohackrxiv.ttl -G http://localhost:8890/sparql-graph-crud-auth --data-urlencode graph=https://BioHackrXiv.org/graph\n"
