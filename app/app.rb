# encoding: utf-8
require 'sinatra'
require 'json'

class WsApp < Sinatra::Application
  enable :sessions
  FIXTURES = YAML.load_file File.expand_path("../../spec/fixtures/main.yml", __FILE__)

  configure :production do
    set :clean_trace, true
  end

  configure :development do
    # ...
  end
  
  configure :test do
    set :clean_trace, false
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

#require_relative 'models/init'
#require_relative 'helpers/init'
require_relative 'routes/init'

