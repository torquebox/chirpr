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

get '/:username' do
  @profile = Profile.get( params[:username] )
  @chirps  = @profile.chirps
  haml :root
end

