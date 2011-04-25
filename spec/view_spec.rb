require "#{File.dirname(__FILE__)}/spec_helper"

describe 'application views' do
  include Rack::Test::Methods

  def app
    @app ||= Chirpr::Application.new
  end

  def mock_app(&block) 
    @app = Class.new(Chirpr::Application, &block) 
  end 

  def profile
    @profile ||= Profile.new(:name=>'matz')
  end

  def login
    mock_app do
      def login_required
        true
      end

      def haml( template )
        true
      end
    end
  end

  context "when logged in" do

    before( :each ) { login }

    it 'renders :root with GET /home' do # show the dashboard
      # TODO: Figure out wtf is up
      #app.should_receive( :haml ).with( :root )
      get '/home'
    end

  end

end
