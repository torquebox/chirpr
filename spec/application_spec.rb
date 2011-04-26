require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    @app ||= Chirpr::Application.new
  end

  def profile
    @profile ||= Profile.new(:name=>'matz')
  end

  def mock_app(&block) 
    @app = Class.new(Chirpr::Application, &block) 
  end 

  def login
    mock_app do
      def login_required
        true
      end
      def get_profile( name )
        Profile.new(:name=>name)
      end
    end
  end

  before( :each ) do
    Profile.stub(:get ).with( profile.name ).and_return( profile )
  end
  
  context 'all requests' do
    before :each do
      mock_app do
      end
    end

    it 'responds to GET /' do # show all chirps
      get '/'
      last_response.should be_ok
    end
  
    it 'responds to GET /:username' do 
      get profile.name
      last_response.should be_ok
    end
  
    it 'responds to GET /login' do
      get '/login'
      last_response.should be_ok
    end
  
    it 'responds to GET /logout' do
      get '/logout'
      last_response.should be_redirect
    end
  
    it 'responds to GET /profiles with all Profiles' do
      Profile.should_receive( :all ).and_return( [] )
      get '/profiles'
      last_response.should be_ok
    end
  end

  context "when logged in" do

    before( :each ) { login }

    it 'responds to GET /home' do # show the dashboard
      get '/home'
      last_response.should be_ok
    end

    it 'responds to GET /followers' do
      get '/followers'
      last_response.should be_ok
    end
  
    it 'responds to GET /friends' do
      get '/friends'
      last_response.should be_ok
    end

    it 'responds to POST /follow' do
      Profile.should_receive(:get).with("1")
      post '/follow', :id=>1
      last_response.should be_ok
    end

    it 'responds to POST /unfollow' do
      Profile.should_receive(:get).with("1")
      post '/follow', :id=>1
      last_response.should be_ok
    end

  end


  context "when not logged in" do
    
    it 'responds to GET /home with a redirect' do # show the dashboard
      get '/home'
      last_response.should be_redirect
    end

    it 'responds to GET /followers with a redirect' do
      get '/followers'
      last_response.should be_redirect
    end
  
    it 'responds to GET /friends with a redirect' do
      get '/friends'
      last_response.should be_redirect
    end

    it 'responds to POST /follow with a redirect' do
      post '/follow', :id=>1
      last_response.should be_redirect
    end

    it 'responds to POST /unfollow with a redirect' do
      post '/unfollow', :id=>1
      last_response.should be_redirect
    end
  end

end
