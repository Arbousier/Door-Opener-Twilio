# encoding: utf-8
require 'json'

class WsApp < Sinatra::Application
  before /phone/ do
    puts env.inspect + "\n\n"
  end

  before do
    if (env['TOKEN'] || env['X-TOKEN'] || env['HTTP-TOKEN'] || env['HTTP_TOKEN'])
      token = env['TOKEN'] || env['X-TOKEN'] || env['HTTP-TOKEN'] || env['HTTP_TOKEN']
      unless FIXTURES['tokens'].include? token
        halt 403, "forbidden"
      end
    else
      halt 403, "error"
    end
  end

  get "/" do
    "<h1>Hello world !</h1>"
  end

  post "/phone/:number" do
    "ok"
  end
 
end