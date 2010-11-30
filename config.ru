%w[rubygems sinatra dyndns-server].each { |m| require m }

set :run, false
set :environment, :development

run Sinatra::Application

