require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'torquebox'
require 'sinatra-twitter-oauth'
require File.join(File.dirname(__FILE__), 'environment')

set :twitter_oauth_config, :key => 'foo-key',
                           :secret   => 'foo-secret',
                           :callback => 'example.com/foo/auth',
                           :login_template => {:text=>'<a href="/connect">Login using Twitter</a>'}

get '/login' do
  haml :root
end

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
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

# This is a wildcard route - it has to be the last one
get '/:username' do
  @profile = Profile.get( params[:username] )
  @chirps  = @profile.chirps
  haml :root
end

# Monkey patch this thing so we can create new profiles when needed
module Sintra::TwitterOAuth
  module Helpers
    def authenticate!
      access_token = get_access_token
    
      if @client.authorized?
        session[:access_token] = access_token.token
        session[:secret_token] = access_token.secret
        session[:user] = @client.info

        session[:user]
        unless Profile.get( @client.info.screen_name )
          @profile = Profile.create( :name => @client.info.screen_name )
        end
      else
        nil
      end
    end
  end
end
