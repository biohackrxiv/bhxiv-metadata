#! /usr/bin/env ruby
#
# We use JSON-LD for exchanging metadata. For an explanation see, for
# example: https://w3c.github.io/json-ld-bp/    (explanation)
#          http://niem.github.io/json/tutorial/ (implementation)

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'erb'
require 'fileutils'

$stderr.print "BioHackrXiv metadata generator...\n"

events = YAML.load_file('etc/events.yaml')['events']
papers = YAML.load_file('etc/papers.yaml')['papers']

HEADER = <<HEADER
{
  "@context": "https://biohackrxiv.org/resource/",
  "id": "https://biohackrxiv.org/list",
  "type": "publications",
  "name": "Publication List",
  "issuer": "https://biohackrxiv.org/",
  "issued": "#{Time.new.to_s}",
HEADER

print HEADER

print "  \"events\": [\n"

events.each_with_index do | e,i |
  print "    ,\n" if i>0
  name,event = e
  print <<EVENT
    {
      "@id": "#{event['url']}",
      "type": "event",
      "name": "#{name}",
      "description": "#{event['txt']}"
    }
EVENT
end

print "  ],\n"
print "  \"publications\": [\n"

papers.each_with_index do |paper,i|
  print "    ,\n" if i>0
  print <<PAPER
  {
    "@id": "#{paper['id']}",
    "type": "publication",
    "event": "#{paper['event']}",
    "doi": "#{paper['doi']}",
    "url": "#{paper['url']}"
  }
PAPER
end

print "  ]}\n"
