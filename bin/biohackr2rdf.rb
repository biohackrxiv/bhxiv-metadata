#! /usr/bin/env ruby

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'erb'

OUTPUT="biohackrxiv.ttl"

rdf_paper_template = <<PTEMPLATE
<<%= id %>> <https://schema.org/sameAs> <<%= doi %>> .

PTEMPLATE


print "BioHackrXiv metadata generator...\n"

papers = YAML.load_file('etc/papers.yaml')['papers']

File.open(OUTPUT, 'w') do |file|
  papers.each do |paper|
    pp paper
    url = paper['url']
    id = paper['id']
    doi = paper['doi']
    print "Fetching '#{url}'...\n"
    uri = URI.parse(url)
    md = Net::HTTP.get(uri) # fetch markdown
    info = YAML.parse(md)
    # pp info
    renderer = ERB.new(rdf_paper_template)
    file.print(output = renderer.result(binding))
  end
end

print "Wrote RDF to #{OUTPUT}\n"
