#! /usr/bin/env ruby

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'erb'

OUTPUT="biohackrxiv.ttl"

RDF_HEADER = <<HEADER
@prefix bhx: <http://biohackerxiv.org/resource> .

HEADER

rdf_event_template = <<ETEMPLATE
<<%= url %>> rdf:label "<%= descr %>" ;
    rdf:ID "<%= name %>"
    a <https://schema.org/Event> .
ETEMPLATE

rdf_paper_template = <<PTEMPLATE
<<%= id %>> <http://purl.org/dc/elements/1.1/title> "<%= title %>" ;
    <https://schema.org/sameAs> <<%= doi %>> ;
    <https://schema.org/url> <<%= url %>> ;
    bhx:Event <<%= event %>> .

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
    renderer = ERB.new(rdf_event_template)
    file.print(output = renderer.result(binding))
  end
  file.print("\n")
  papers.each do |paper|
    pp paper
    url = paper['url']
    id = paper['id']
    doi = paper['doi']
    print "Fetching '#{url}'...\n"
    uri = URI.parse(url)
    # fetch markdown
    md = ""
    Net::HTTP.get(uri).split("\n").each { |line|
      break if line =~ /^$/
      md += line+"\n" if md != "---"
    }
    print md

    info = YAML.load(md).merge(paper)
    pp info
    title = info['title']
    id = info['event']
    event = events[id]['url']
    raise "Missing event for #{id}" if !event
    renderer = ERB.new(rdf_paper_template)
    file.print(output = renderer.result(binding))
  end
end

print "Wrote RDF to #{OUTPUT}\n"
