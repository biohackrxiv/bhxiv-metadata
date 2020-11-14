#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'

require 'net/http'
require 'json'
require 'ostruct'

SPARQL_HEADER="
prefix bhx: <http://biohackerxiv.org/resource>
prefix dc: <http://purl.org/dc/elements/1.1/>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
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

  QUERY = <<QUERY_BODY
SELECT  ?url ?name ?descr
FROM    <https://BioHackrXiv.org/graph>
WHERE   {
 ?url rdfs:label ?name .
 ?url rdfs:comment ?descr
}
QUERY_BODY

  # list = sparql(QUERY, lambda { |rec| rec } )
  list = sparql(QUERY)
  p list
  biohackathons = {}
  list.each { |rec| biohackathons[rec[:name]] = {url: rec[:url], descr: rec[:descr]} }
  p biohackathons
  papers = [ "TEST" ]
  erb :list, :locals => { bh: bh, link: biohackathons[bh][:url], descr: biohackathons[bh][:descr], bhs: biohackathons, papers: papers }
end
