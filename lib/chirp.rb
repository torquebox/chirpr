
class Chirp
  include DataMapper::Resource

  property :id,         Serial
  property :message,    String  
  property :created_at, DateTime

  validates_presence_of :message
  belongs_to :profile

  def self.latest
    all(:order => [:created_at.desc], :limit => 10)
  end
end
