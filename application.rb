require 'rubygems'
require 'bundler/setup'
require 'torquebox'

require 'sinatra'
require 'sinatra-twitter-oauth'

require 'sass'
require 'rack-flash'
require 'sinatra/url_for'

require File.join(File.dirname(__FILE__), 'environment')
require 'helpers'


module Chirpr
  class Application < Sinatra::Base

    register Sinatra::TwitterOAuth
    use Rack::Flash
  
    
    get '/login' do
      haml :root
    end

    helpers Sinatra::UrlForHelper
    helpers Chirpr::Helpers

    configure do

      unless ENV['oauth_key'] && ENV['oauth_secret']
        puts "ENV['oauth_key'] and ENV['oauth_secret'] not set. Can't do much without them."
      end
      
      enable :sessions

      set :views, "#{File.dirname(__FILE__)}/views"
      set :twitter_oauth_config, :key => ENV['oauth_key'],
                                 :secret   => ENV['oauth_secret'],
                                 :callback => 'http://chirpr.thequalitylab.com/auth',
                                 :login_template => {:haml=>:login}
    end
    
    error do
      e = request.env['sinatra.error']
      Kernel.puts e.backtrace.join("\n")
      'Application error'
    end

    ['/home', '/friends', '/followers', '/follow', '/unfollow', '/chirp'].each do |path|
      before path do
        login_required
      end
    end

    before do
      puts "ENV['oauth_key'] and ENV['oauth_secret'] not set. Can't do much without them." unless configured?
      # Will be null if not logged in
      @profile = get_profile( screen_name )
    end
    
    get '/' do
      haml :root
    end
    
    get '/profiles' do
      @profiles = Profile.all
      haml :profiles
    end
    
    get '/home' do
      haml :home
    end
    
    get '/friends' do
      haml :friends
    end
    
    get '/followers' do
      haml :followers
    end

    post '/follow' do
      if @friend = Profile.get(params[:id])
        @profile.follow( @friend )
        flash[:notice] = "You are now following #{@friend.name}"
      else
        flash[:notice] = "Sorry. Can't seem to find the person you're looking for."
      end
      haml :home
    end

    post '/unfollow' do
      if @friend = Profile.get(params[:id]) 
        @profile.unfollow( @friend )
        flash[:notice] = "You are no longer following #{@friend.name}"
      else
        flash[:notice] = "Sorry. Can't seem to find the person you're looking for."
      end
      haml :home
    end

    post '/chirp' do
      @profile.chirps.create(:message=>params[:message], :created_at=>Time.now)
      redirect to('/home')
    end

    get '/main.css' do
      scss :main
    end
    
    
    # This is a wildcard route - it has to be the last one
    get '/:username' do
      profile = get_profile( params[:username] )
      @chirps = profile ? profile.chirps : []
      haml :chirps
    end
  end
end

  
# Monkey patch this thing so we can create new profiles when needed
module Sinatra::TwitterOAuth
  module Helpers

    def get_profile( name )
      return nil unless name
      Profile.first( :name => name.downcase )
    end

    def get_or_create_profile( name )
      name.downcase!
      @profile = get_profile( name )
      unless @profile
        @profile = Profile.create!( :name => name, :created_at => Time.now, :updated_at => Time.now )
      end
    end

    def authenticate!
      access_token = get_access_token
    
      if @client.authorized?
        session[:access_token] = access_token.token
        session[:secret_token] = access_token.secret
        session[:user] = @client.info

        get_or_create_profile( @client.info["screen_name"] )

        session[:user]
      else
        nil
      end
    end
  end
end

