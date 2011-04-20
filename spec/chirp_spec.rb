require "#{File.dirname(__FILE__)}/spec_helper"

describe 'chirp' do
  before(:each) do
    @chirp = Chirp.new(:message => 'Hello universe', :profile_id => 1)
  end

  it 'should be valid' do
    @chirp.should be_valid
  end

  it 'should require a message' do
    @chirp = Chirp.new(:profile_id => 1)
    @chirp.should_not be_valid
    @chirp.errors[:message].should include("Message must not be blank")
  end

  it 'should require a profile' do
    @chirp = Chirp.new(:message => 'Anonymous message')
    @chirp.should_not be_valid
  end


end
