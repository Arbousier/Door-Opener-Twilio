require "spec_helper"

describe 'Twilio' do
  include Rack::Test::Methods
  let(:number) { '12345' }
  subject { post '/twilio/door', 'From' => number }

  before {
    Notifier.stub(:notify)
    Door.stub(:open)
  }

  context "when known number" do
    let(:is_authorized?) { false }
    before do
      Number.stub(:get).and_return('number' => number, 'name' => 'joe',
        'authorized' => is_authorized?)
    end


    context "when not authorized" do

      it { should be_ok }
      it "should NOT open the door" do
        should_not_be_open
        subject
      end
    end

    context "when authorized" do
      let(:is_authorized?) { true }

      it { should be_ok }
      it "should open the door" do
        should_be_open_by 'joe'
        subject
      end
    end
  end


  context "when unkonwn number" do

    it { should be_ok }
    it "should not open the door" do
      should_not_be_open
      subject
    end
  end

  it "should respond on human" do
    get '/twilio/human', { 'From' => number, 'Digits' => '1' }
    last_response.should be_ok
  end

private
  def should_not_be_open
    Door.should_not_receive :open
    Notifier.should_not_receive :notify
  end

  def should_be_open_by user
    Door.should_receive :open
    Notifier.should_receive :notify, with: 'joe'
  end
end