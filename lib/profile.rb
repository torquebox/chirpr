
class Profile

  class Link
    include DataMapper::Resource

    storage_names[:default] = 'profiles_links'

    property :id, Serial

    belongs_to :follower, 'Profile', :key => true
    belongs_to :friend, 'Profile', :key => true
  end

  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :required => true
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :name

  has n, :chirps

  # Friend/follower relationship links
  has n, :links_to_friends, 'Profile::Link', :child_key => [:follower_id]
  has n, :links_to_followers, 'Profile::Link', :child_key => [:friend_id]

  # Make the friend/follower links provide direct access to the follower/friend Profiles
  has n, :friends, self, :through => :links_to_friends, :via => :friend
  has n, :followers, self, :through => :links_to_followers, :via => :follower

  # Follow one or more friends
  def follow(friends)
    links_to_friends.concat(Array(friends))
    save
    self
  end

  # Unfollow one or more friends
  def unfollow(friends)
    links_to_friends.all(:followed=>Array(friends)).destroy!
    reload
    self
  end
end
