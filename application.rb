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
    end

    configure do
      enable :sessions
      set :views, "#{File.dirname(__FILE__)}/views"
    set :twitter_oauth_config, :key => '65nujhqwZHMbRpA5dT8aqQ',
                               :secret   => 'n2CaFV0d8Orz5nqrpuOMAFg6UxGyovD9dztUraDZas',
                               :callback => 'http://chirpr.thequalitylab.com/auth',
                               :login_template => {:text=>'<a href="/connect">Login using Twitter</a>'}
    end
    
    error do
      e = request.env['sinatra.error']
      Kernel.puts e.backtrace.join("\n")
      'Application error'
    end
    
    get '/' do
      haml :root
    end
    
    get '/profiles' do
      Profile.all
      haml :root
    end
    
    get '/home' do
      login_required
      haml :root
    end
    
    get '/friends' do
      login_required
      haml :root
    end
    
    get '/followers' do
      login_required
      haml :root
    end

    post '/follow' do
      login_required
      @follow = Profile.get(params[:id])
      haml :root
    end

    get '/main.css' do
      scss :main
    end
    
    post '/unfollow' do
      login_required
      haml :root
    end
    
    # This is a wildcard route - it has to be the last one
    get '/:username' do
      @profile = Profile.first( :name=>params[:username].downcase )
      @chirps  = @profile.chirps
      haml :root
    end
  end
end

  
# Monkey patch this thing so we can create new profiles when needed
module Sinatra::TwitterOAuth
  module Helpers

    def get_or_create_profile( name )
      name.downcase!
      @profile = Profile.get( name )
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

