require "#{File.dirname(__FILE__)}/spec_helper"

describe 'profile' do

  it 'should be valid' do
    profile = Profile.new(:name => 'test user')
    profile.should be_valid
  end

  it 'should require a name' do
    profile = Profile.new
    profile.should_not be_valid
    profile.errors[:name].should include("Name must not be blank")
  end

  it 'should enforce a unique name' do
    profile = Profile.create(:name=>'foo')
    other   = Profile.new(:name=>'foo')
    other.should_not be_valid
  end

  it 'should have n chirps' do
    profile = Profile.create(:name => 'test user')
    profile.chirps.should == []
  end

  it 'should have n followers' do
    profile = Profile.create(:name => 'test user')
    profile.followers.should == []
  end

  it 'should have n friends' do
    profile = Profile.create(:name => 'test user')
    profile.friends.should == []
  end

  it 'should respond to follow(profile) by creating a friendship' do
    profile = Profile.create(:name => 'test user')
    friend = Profile.create(:name=>'another user')
    profile.follow( friend )
    profile.friends.first.should == friend
  end

  it 'should respond to unfollow(profile) by removing a friendship' do
    profile = Profile.create(:name => 'test user')
    friend = Profile.create(:name=>'another user')
    profile.follow( friend )
    profile.friends.count.should == 1
    profile.unfollow( friend )
    profile.has_friends?.should == false
  end

  it 'should respond to follow(profile) by creating a follower' do
    profile = Profile.create(:name => 'test user')
    friend = Profile.create(:name=>'another user')
    profile.follow( friend )
    friend.followers.first.should == profile
  end

end
