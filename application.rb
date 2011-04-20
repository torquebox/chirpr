require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'torquebox'
require File.join(File.dirname(__FILE__), 'environment')

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

get '/home' do
  haml :root
end

get '/login' do
  haml :root
end

get '/:username' do
  haml :root
end

