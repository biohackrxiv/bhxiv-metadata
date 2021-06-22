#! /usr/bin/env ruby
#
# Fetch metadata from OSF using the API

require 'yaml'
require 'json'
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

papers2 = papers
num = 0
while url
  num += 1
  fn = OUTDIR+"/page#{num}.json"
  if not options[:no_fetch]
    $stderr.print "Fetching '#{url}'...\n"
    uri = URI.parse(url)
    data = Net::HTTP.get(uri)
    File.open(fn,"w") { |f|
      f.write(data)
    }
  else
    data = File.read(fn)
  end
  $stderr.print "Processed #{fn}\n"

  osf_ps = JSON.parse(data)

  list =
    osf_ps['data'].map do | o |
      attr = o['attributes']
      rec = {}
      if attr['is_published'] and not attr['is_preprint_orphan']
        date = attr['date_published'][0..9]
        rec = { 'id': "https://biohackrxiv.org/"+o['id'],
                'title': attr['title'],
                'date_published': date
              }
      end
      rec
  end
  papers2 += list
  url = osf_ps['links']['next']
end
print papers2.flatten.to_yaml

# Fetch info on a paper https://api.osf.io/v2/preprints/wu9et/
