require File.join(File.dirname(__FILE__), 'application')

set :run, false
set :environment, :development

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)

run Chirpr::Application
