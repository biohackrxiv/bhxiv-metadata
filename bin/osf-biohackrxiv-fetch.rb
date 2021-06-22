#! /usr/bin/env ruby
#
# Fetch metadata from OSF using the API

require 'yaml'
require 'pp'
require 'uri'
require 'net/http'
require 'fileutils'
require 'optparse'

USAGE =<<EOU

  Nothing yet

EOU

$stderr.print "BioHackrXiv fetch OSF metadata...\n"

options = {show_help: false}
# options[:show_help] = true if ARGV.size == 0

opts = OptionParser.new do |o|
  o.banner = "Usage: #{File.basename($0)} [options]\n\n"
  o.on("--no-fetch", "Reuse fetched data") do |v|
    options[:no_fetch] = true
  end
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

rescue OptionParser::InvalidOption => e
  options[:invalid_argument] = e.message
end

$stderr.print options if options[:debug]

events = YAML.load_file('etc/events.yaml')['events']
papers = YAML.load_file('etc/papers.yaml')['papers']

# Fetch list of publications
#   curl https://api.osf.io/v2/providers/preprints/biohackrxiv/preprints/ |jq -C "." |less -R

OUTDIR = "./papers/OSF"

url = "https://api.osf.io/v2/providers/preprints/biohackrxiv/preprints/"
fn = OUTDIR+"/page1.json"
if not options[:no_fetch]
  $stderr.print "Fetching '#{url}'...\n"
  uri = URI.parse(url)
  data = Net::HTTP.get(uri)
  $stderr.print "Writing #{fn}...\n"
  File.open(fn,"w") { |f|
    f.write(data)
  }
else
  data = File.read(fn)
end

print data
# Fetch info on a paper https://api.osf.io/v2/preprints/wu9et/
