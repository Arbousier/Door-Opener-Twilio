require "spec_helper"

describe 'Twilio' do
  include Rack::Test::Methods
  let(:number) { '12345' }
  subject { post '/twilio/door', 'From' => number }

  context "when konwn number" do
    let(:is_authorized?) { false }
    before do
      Number.stub(:get).and_return 'number' => number, 'name' => 'joe', 'authorized' => is_authorized?
    end


    context "when not authorized" do

      it { should be_ok }
      it "should NOT open the door" do
        Door.should_not_receive :open
        subject
      end
    end

    context "when authorized" do
      let(:is_authorized?) { true }

      it { should be_ok }
      it "should open the door" do
        Door.should_receive :open
        subject
      end
    end
  end


  context "when unkonwn number" do

    it { should be_ok }
    it "should not open the door" do
      Door.should_not_receive :open
      subject
    end
  end

  it "should respond on human" do
    get '/twilio/human', { 'From' => number, 'Digits' => '1' }
    last_response.should be_ok
  end
end