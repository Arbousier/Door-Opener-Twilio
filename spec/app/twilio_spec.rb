require "spec_helper"

describe 'Twilio' do
  include Rack::Test::Methods
  let(:number) { '12345' }

  it "should respond to door" do
    post '/twilio/door', { 'From' => number }
    last_response.should be_ok
  end

  it "should respond on human" do
    get '/twilio/human', { 'From' => number, 'Digits' => '1' }
    last_response.should be_ok
  end

  context "when wrong number" do
    let(:unknown_number) { '00000' }

    it "should not open the door" do
      Door.should_not_receive :open
      post '/twilio/door', { 'From' => unknown_number }
    end
  end
end