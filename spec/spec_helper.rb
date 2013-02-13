# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["SINATRA_ENV"] ||= 'test'
ENV["RACK_END"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require File.expand_path("../../app/app", __FILE__)
require 'rspec'
require 'rspec/autorun'
require 'rack/test'
require 'yaml'

QUOTES = YAML.load_file File.expand_path("../../config/quotes.yml", __FILE__)
CLOUDANT = YAML.load_file File.expand_path("../../config/cloudant.yml", __FILE__)

set :environment, :test

RSpec.configure do |config|
  config.order = "random"
end

# rspec related helpers
def app
  WsApp.new
end

def json_response
  JSON.parse(last_response.body)
end