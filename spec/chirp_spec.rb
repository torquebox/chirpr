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

  it 'should accept messages up to 141 characters' do
    @chirp.message = 'A'*141
    @chirp.should be_valid
  end

  it 'should not be valid if message is > 141 characters' do
    @chirp.message = 'A'*142
    @chirp.should_not be_valid
  end

end
