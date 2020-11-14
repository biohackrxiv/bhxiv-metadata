#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

require 'net/http'
require 'json'
require 'ostruct'

SPARQL_HEADER="
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix dc: <http://purl.org/dc/terms/>
prefix bhx: <http://biohackerxiv.org/resource/>
prefix schema: <https://schema.org/>
"

def sparql q, transform = nil
  q = SPARQL_HEADER+q
  p q
  api_url = "http://sparql.genenetwork.org/sparql/?default-graph-uri=&format=application%2Fsparql-results%2Bjson&timeout=0&debug=on&run=+Run+Query+&query=#{ERB::Util.url_encode(q)}"

  response = Net::HTTP.get_response(URI.parse(api_url))
  data = JSON.parse(response.body)
  vars = data['head']['vars']
  results = data['results']['bindings']
  results.map { |rec|
    res = {}
    vars.each { |name|
      res[name.to_sym] = rec[name]['value']
    }
    if transform
      transform.call(res)
    else
      res
    end
  }
end

get '/' do
  'BioHackrXiv <a href="/list">examples</a>'
end

get '/list' do
  bh = params[:bh]

  EVENTS = <<SPARQL_EVENTS
SELECT  ?url ?name ?descr
FROM    <https://BioHackrXiv.org/graph>
WHERE   {
 ?url schema:name ?name .
 ?url schema:description ?descr
}
SPARQL_EVENTS

  # list = sparql(QUERY, lambda { |rec| rec } )
  list = sparql(EVENTS)
  p list
  biohackathons = {}
  list.each { |rec| biohackathons[rec[:name]] = {url: rec[:url], descr: rec[:descr]} }
  p biohackathons

  PAPERS = <<SPARQL_PAPERS
SELECT  ?title ?url
FROM    <https://BioHackrXiv.org/graph>
WHERE   {
  ?bh schema:name "#{bh}" .
  ?url bhx:Event ?bh ;
    dc:title ?title .
}
SPARQL_PAPERS

  papers = sparql(PAPERS, lambda { |paper| OpenStruct.new(paper) } )

  papers.each do | paper |

    AUTHORS = <<SPARQL_AUTHORS
SELECT  ?author
FROM    <https://BioHackrXiv.org/graph>
WHERE   {
  <#{paper.url}> dc:contributor ?author
}
SPARQL_AUTHORS

    authors = sparql(AUTHORS, lambda { |paper| paper[:author] } )
    p authors
    paper.authors = authors

  end

  p papers

  erb :list, :locals => { bh: bh, link: biohackathons[bh][:url], descr: biohackathons[bh][:descr], bhs: biohackathons, papers: papers }
end
