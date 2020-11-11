#! /usr/bin/env ruby

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'erb'

OUTPUT="biohackrxiv.ttl"

bh_uris = {
  "Elixir2019" => "https://github.com/elixir-europe/BioHackathon-projects-2019",
  "Elixir2020" => "https://github.com/elixir-europe/BioHackathon-projects-2020",
  "Fukuoka2019" => "http://2019.biohackathon.org/",
}

RDF_HEADER = <<HEADER
@prefix bhx: <http://biohackerxiv.org/resource> .

HEADER

rdf_event_template = <<ETEMPLATE
<<%= url %>> rdf:label "<%= name %>" ;
    a <https://schema.org/Event> .
ETEMPLATE

rdf_paper_template = <<PTEMPLATE
<<%= id %>> <http://purl.org/dc/elements/1.1/title> "<%= title %>" ;
    <https://schema.org/sameAs> <<%= doi %>> ;
    <https://schema.org/url> <<%= url %>> ;
    <bhx:Event> <<%= event %>> .

PTEMPLATE

print "BioHackrXiv metadata generator...\n"

papers = YAML.load_file('etc/papers.yaml')['papers']

File.open(OUTPUT, 'w') do |file|
  file.print(RDF_HEADER)
  bh_uris.each do | name, url |
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
    event = bh_uris[info['event']]
    raise "Missing event for #{info['event']}" if !event
    renderer = ERB.new(rdf_paper_template)
    file.print(output = renderer.result(binding))
  end
end

print "Wrote RDF to #{OUTPUT}\n"
