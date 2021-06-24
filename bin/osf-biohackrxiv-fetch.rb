#! /usr/bin/env ruby
#
# Fetch metadata from OSF using the API - essentially combines an
# existing papers.yaml file with metadata and writes it out. Make sure
# not to overwrite ./etc/papers.yaml - but use a 2-step approach
#
# Also make sure the IDs have no trailing slash.

require 'yaml'
require 'json'
require 'pp'
require 'uri'
require 'net/http'
require 'fileutils'
require 'optparse'

USAGE =<<EOU

  Fetch metadata from OSF

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

papers2 = []
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
        rec = { 'id' => "https://biohackrxiv.org/"+o['id'],
                'title' => attr['title'],
                'date_published' => date
              }
      end
      rec
  end
  papers2 += list
  url = osf_ps['links']['next']
end

p2 = papers2.flatten

# now combine p2 and the original papers
# First create a hash of all OSF entries in p2
h = {}
p2.each do | v |
  h[v["id"]] = v
end

# now 'h' contains all OSF records indexed by "id"
# run through the existing entries and combine
papers.each do | v |
  id = v["id"]
  #p [id,h[id],v]
  if h[id]
    h[id] = h[id].merge(v)
    #p [id,h[id]]
    #exit 1 if id == "https://biohackrxiv.org/km9ux/"
  end
  #p v
  #exit 1 if id == "https://biohackrxiv.org/km9ux/"
end


# In the next step we fetch the individual papers and store them
# Fetch info on a paper https://api.osf.io/v2/preprints/wu9et/

h.each { |id,v|
  url = "https://api.osf.io/v2/preprints/"+File.basename(id)+"/"
  fn = OUTDIR+"/"+File.basename(id)+".json"
  if not options[:no_fetch]
    $stderr.print "Fetching '#{url}'...\n"
    print `curl -s "#{url}" > #{fn}`
  end
  raise "Can not find #{fn}. Run a fetch!" if not File.exist?(fn)
  pjson = JSON.parse(File.read(fn))
  attr = pjson['data']['attributes']
  v['doi'] = pjson['data']['links']['preprint_doi']
}

# remap to array
a = []
h.sort_by { |k,v| v["date_published"] }.each { |k,v|
  v["id"].chomp('/')
  a.push v
}
print({"papers" => a.reverse}.to_yaml)
