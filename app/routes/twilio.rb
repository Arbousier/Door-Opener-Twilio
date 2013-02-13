# encoding: utf-8
require 'json'

class WsApp < Sinatra::Application

  post '/twilio/door' do
    num = Number.get(:number => params['From'])
    if num['authorized']
      Door.open
      Twilio::TwiML::Response.new do |r|
        lang = ['fr', 'it', 'es', 'en'].shuffle.first
        lang = num['lang'] if num['lang'] != 'rand'
        case lang
        when 'fr'
          r.Say "Bonjour #{num['name']}, la porte est ouverte, tu peux la pousser.", :voice => ['woman','man'].shuffle.first, :language => 'fr'
        when 'it'
          r.Say "Ciao #{num['name']}, la porta è aperta", :voice => ['woman','man'].shuffle.first, :language => 'it'
        when 'es'
          r.Say "Hola #{num['name']}, la puerta hesta abierta", :voice => ['woman','man'].shuffle.first, :language => 'es'
        else
          r.Say "Hello #{num['name']}, the door is open, you can now push it.", :voice => ['woman','man'].shuffle.first
          r.Say "Here is a quote for you :"
          r.Say Quote.random
        end
      end.text
    else
      Twilio::TwiML::Response.new do |r|
        r.Gather :numDigits => '1', :action => '/twilio/human', :method => 'get' do |g|
          g.Say "I don't know you, Do you want to speak to a human ? Press 1 if you do."
          g.Say 'Press any other key to start over.'
        end
      end.text
    end
  end

  get '/twilio/human' do
    redirect '/twilio/door' unless params['Digits'] == '1'
    Twilio::TwiML::Response.new do |r|
      r.Dial Number.on_duty ### Connect the caller to a human
      r.Say 'The call failed or the remote party hung up. Goodbye.'
    end.text
  end

end