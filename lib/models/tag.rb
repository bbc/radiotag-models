require 'time'
require 'bbc_service_map'
require 'dm-timestamps'

class Tag
  include DataMapper::Resource

  property :id,         Serial
  property :station,    String,  :required => true
  property :time,       Integer, :required => true
  property :uuid,       String,  :default => lambda { |r,p| GenerateID::uuid }
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_numericality_of :time, :gte => Time.parse('2011-01-01').utc.to_i

  belongs_to :device, :required => false

  def episode_data
    @episode_data ||= Solr.new(time, programmes_id).episode
  end

  def iplayer_url
    "http://www.bbc.co.uk/iplayer/episode/#{episode_data['episode_pid']}?t=#{offset_time}s"
  end

  def title
    episode_data['display_title']
  end

  def description
    episode_data['description']
  end

  def thumbnail_url
    "http://node1.bbcimg.co.uk/iplayer/images/episode/#{episode_pid}_150_84.jpg"
  end

  def offset_time
    start_time = Time.parse(episode_data['start_time']).to_i
    time - start_time
  end

  def programmes_id
    BBCRD::ServiceMap.lookup(station).programmes_id.split('/').first
  end

  def service_title
    BBCRD::ServiceMap.lookup(station).title
  end

  def programmes_url
    "http://www.bbc.co.uk/programmes/#{episode_pid}"
  end

  def canonical_url
    "http://www.bbc.co.uk/programmes/#{episode_pid}?t=#{offset_time}"
  end

  def episode_pid
    episode_data['episode_pid']
  end
end
