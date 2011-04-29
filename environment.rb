require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'Chirpr',
                 :author => 'Red Hat, Inc.',
                 :url_base => 'http://localhost:8080/',
                 :twitter_key => SiteConfig.twitter_key,
                 :twitter_secret => SiteConfig.twitter_secret,
                 :twitter_callback => SiteConfig.twitter_callback
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "postgres://chirpr:chirpr@localhost/chirpr"))

  unless ENV['oauth_key'] && ENV['oauth_secret']
    puts "ENV['oauth_key'] and ENV['oauth_secret'] not set. Can't do much without them."
  end

  enable :sessions

  set :views, "#{File.dirname(__FILE__)}/views"

end
