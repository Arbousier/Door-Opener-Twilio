require "spec_helper"

describe 'Twilio' do
  include Rack::Test::Methods

  it "should respond to door" do
    post '/twilio/door', {'From' => Number.all.first['number']}
    last_response.should be_ok
  end

  it "should respond on human" do
    get '/twilio/human', {'From' => Number.all.first['number'], 'Digits' => '1'}
    last_response.should be_ok
  end
end