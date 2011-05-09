
class Chirp
  include DataMapper::Resource

  property :id,         Serial
  property :message,    String,  :length => 141
  property :created_at, DateTime

  validates_length_of   :message, :within => 1..141

  belongs_to :profile

  def self.latest
    all(:order => [:created_at.desc], :limit => 10)
  end
end
