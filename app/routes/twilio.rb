# encoding: utf-8
require 'json'

# twilio related routes
class WsApp < Sinatra::Application

  post '/twilio/door' do
    num = Number.get(:number => params['From'])
    if num && num['authorized']
      answer_and_open(num)
    else
      answer_and_redirect(num)
    end
  end

  get '/twilio/human' do
    redirect '/twilio/door' unless params['Digits'] == '1'
    Twilio::TwiML::Response.new do |r|
      r.Dial Number.on_duty ### Connect the caller to a human
      r.Say 'The call failed or the remote party hung up. Goodbye.'
    end.text
  end

  private
  def answer_and_open(num)
    all_lang_msg = messages_yml
    Door.open
    Notifier.notify num['name']
    Twilio::TwiML::Response.new do |r|
      lang = ['fr', 'it', 'es', 'en'].shuffle.first
      lang = num['lang'] if num['lang'] != 'rand'
      speaker = ['woman','man'].shuffle.first
      messages = all_lang_msg[lang || 'en']
      r.Say "#{messages['hello']} #{num['name']}, #{messages['hello1']}",
        :voice => speaker, :language => lang || 'en'
      r.Say "#{messages['hello2']}",
        :voice => speaker, :language => lang || 'en'
      r.Say Quote.random(lang || 'en')
    end.text
  end

  def answer_and_redirect(num)
    Twilio::TwiML::Response.new do |r|
      r.Gather :numDigits => '1',
        :action => '/twilio/human', :method => 'get' do |g|
        g.Say "I don't know you, Do you want to speak \
          to a human ? Press 1 if you do."
        g.Say 'Press any other key to start over.'
      end
    end.text
  end

  def messages_yml
    YAML.load_file File.expand_path("../../../config/messages.yml", __FILE__)
  end

end