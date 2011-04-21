require "#{File.dirname(__FILE__)}/spec_helper"

describe 'profile' do
  before(:each) do
    @profile = Profile.new(:name => 'test user')
  end

  it 'should be valid' do
    @profile.should be_valid
  end

  it 'should require a name' do
    @profile = Profile.new
    @profile.should_not be_valid
    @profile.errors[:name].should include("Name must not be blank")
  end

  it 'should have n chirps' do
    @profile.chirps.should == []
  end

  it 'should have n followers' do
    @profile.followers.should == []
  end

  it 'should have n friends' do
    @profile.friends.should == []
  end

end
