require 'net/http'
require 'uri'
require 'time'
require 'json'
require 'cgi'
require 'config_helper'         # project needs to provide this

class Solr
  attr_accessor :tag_time, :service_key

  begin
    solr_config = ConfigHelper.load_config("config/solr.yml")
    SOLR_HOST = solr_config[:host] or solr_config["host"] or raise
  rescue => e
    raise RuntimeError, "You must configure the SOLR host in config/solr.yml, e.g.\n:host: solr.example.com"
  end

  def initialize(tag_time, service_key)
    @tag_time = Time.at(tag_time).utc.xmlschema
    @service_key = service_key
  end

  def episode
    if d = data
      d["response"]["docs"].first
    else
      nil
    end
  end

  def data
    begin
      proxy = ENV['http_proxy'] ? URI.parse(ENV['http_proxy']) : OpenStruct.new
      http = Net::HTTP::Proxy(proxy.host, proxy.port, proxy.user, proxy.password).new(SOLR_HOST, 80)

      response = http.get(query_path)
      return JSON.parse(response.body)
    rescue
      return nil
    end
  end

  def query_path
    URI.escape("/solr/select?q=#{solr_query_string}&wt=json")
  end

  def solr_query_string
    [start_term, end_term, service_term].join(" AND ")
  end

  def start_term
    "start_time:[* TO #{tag_time}]"
  end
  def end_term
    "end_time:[#{tag_time} TO *]"
  end
  def service_term
    "service_key:\"#{service_key}\""
  end
end




