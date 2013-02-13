# encoding: utf-8
require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'rest-client'

class WsApp < Sinatra::Application
  enable :sessions
  QUOTES = YAML.load_file File.expand_path("../../config/quotes.yml", __FILE__)

  configure :production do
    set :clean_trace, true
    CLOUDANT = {'host' => ENV['CLOUDANT_HOST'],
      'key' => ENV['CLOUDANT_KEY'],
      'password' => ENV['CLOUDANT_PASSWORD']}
  end

  configure :development do
    CLOUDANT = YAML.load_file File.expand_path("../../config/cloudant.yml", __FILE__)
  end
  
  configure :test do
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  def check_headers(env)
    unless (env['TOKEN'] || env['X-TOKEN'] || env['HTTP-TOKEN'] || env['HTTP_TOKEN'])
      halt 304, "error"
    end
  end

end

class Hash
  def to_json
    JSON.dump(self)
  end
end

require_relative 'models/init'
#require_relative 'helpers/init'
require_relative 'routes/init'

