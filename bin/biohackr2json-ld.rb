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
require 'optparse'

USAGE =<<EOU

  bio-table transforms, filters and reorders table files (CSV, tab-delimited).

EOU

$stderr.print "BioHackrXiv metadata generator...\n"

options = {show_help: false}
# options[:show_help] = true if ARGV.size == 0

opts = OptionParser.new do |o|
  o.banner = "Usage: #{File.basename($0)} [options]\n\n"
  o.on("--debug", "Show debug messages") do |v|
    options[:debug] = true
  end

  o.separator ""

  o.on_tail('-h', '--help', 'Display this help and exit') do
    options[:show_help] = true
  end
end

begin
  opts.parse!(ARGV)

  if options[:show_help]
    print opts
    print USAGE
  end

  # TODO: your code here
  # use options for your logic
rescue OptionParser::InvalidOption => e
  options[:invalid_argument] = e.message
end

$stderr.print options if options[:debug]

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
