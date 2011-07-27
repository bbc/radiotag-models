class Device
  include DataMapper::Resource
  include GenerateID

  property :id,        Serial
  property :token,     String
  property :name,      String
  property :pin,       String, :default => lambda { |r,p| GenerateID::rand_pin }

  has n, :tags
  belongs_to :user, :required => false

end
