require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application.new
  end

  it 'shows all chirps with GET /' do
    get '/'
    last_response.should be_ok
  end

  it 'shows the dashboard with GET /home' do
    get '/home'
    last_response.should be_ok
  end

  it 'shows chirps from a specific user with GET /:username' do
    get '/matz'
    last_response.should be_ok
  end

  it 'shows the login page with GET /login' do
    get '/login'
    last_response.should be_ok
  end


end
