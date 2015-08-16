
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'

require 'uri'
require 'pathname'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'

require 'awesome_print'
require 'open-uri'
require 'byebug'


APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# Set up the database and models
require APP_ROOT.join('config', 'database')




#---
require 'sidekiq'
require 'redis'
require 'sidekiq/api'



require 'twitter'
require 'yaml'
require 'omniauth-twitter'


Dir[APP_ROOT.join('app', 'workers', '*.rb')].each { |file| require file }


if Sinatra::Base.development?
	API_KEYS = YAML::load(File.open('config/token.yaml'))
else
	API_KEYS = {}
	API_KEYS["twitter_consumer_key_id"] = ENV["twitter_consumer_key_id"]
	API_KEYS["twitter_consumer_secret_key_id"] = ENV["twitter_consumer_secret_key_id"]
end


use OmniAuth::Builder do
  provider :twitter, API_KEYS["twitter_consumer_key_id"], API_KEYS["twitter_consumer_secret_key_id"]
end

#----


