class User
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String
  property :password,  BCryptHash

  has n, :devices
  has n, :tags, :through => :devices

  def tags_by_time(options = {})
    self.tags({:order => [:time.desc]}.merge(options))
  end

  # Return an array of array of tags ordered by time and grouped by
  # the day of the year
  def tags_grouped_by_day(options = {})
    self.tags_by_time(options).
      group_by { |t| Time.at(t.time).yday }.
      sort.
      reverse.
      map {|a| a[1]}
  end
end

