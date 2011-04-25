require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'torquebox'
require 'sass'
require 'sinatra-twitter-oauth'
require File.join(File.dirname(__FILE__), 'environment')


module Chirpr
  class Application < Sinatra::Base

    register Sinatra::TwitterOAuth
  
    
    get '/login' do
      haml :root
    end

    helpers do
      def format_time(t)
        # TODO: Format this nicely
        t
      end

      def screen_name
        return nil unless session[:user]
        session[:user]["screen_name"]
      end

    end

    configure do
      enable :sessions
      set :views, "#{File.dirname(__FILE__)}/views"
      set :twitter_oauth_config, :key => 'changeme',
                                 :secret   => 'changeme',
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
        @profile = get_profile( screen_name )
      end
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
      @follow = Profile.get(params[:id])
      haml :root
    end

    post '/unfollow' do
      haml :root
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

