# encoding: utf-8
require 'json'

# main route
class WsApp < Sinatra::Application

  get "/" do
    "<h1>Hello world !</h1>"
  end

end