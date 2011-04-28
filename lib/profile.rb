
class Profile

  # Links profiles together as friends and followers
  # The Profiles that a user follows are friends
  # The Profiles that are following a user are followers
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

  validates_presence_of   :name
  validates_uniqueness_of :name

  has n, :chirps

  # Friend/follower relationship links
  has n, :links_to_friends, 'Profile::Link', :child_key => [:follower_id]
  has n, :links_to_followers, 'Profile::Link', :child_key => [:friend_id]

  # Make the friend/follower links provide direct access to the follower/friend Profiles
  has n, :friends, self, :through => :links_to_friends, :via => :friend
  has n, :followers, self, :through => :links_to_followers, :via => :follower

  # Follow one or more friends
  def follow(others)
    friends.concat(Array(others))
    save
    self
  end

  # Unfollow one or more friends
  def unfollow(others)
    links_to_friends.all(:friend=>Array(others)).destroy!
    reload
    self
  end

  def follows?(friend)
    friends.include?( friend )
  end

  def has_friends?
    friends.count > 0
  end

  def has_followers?
    followers.count > 0
  end
end
