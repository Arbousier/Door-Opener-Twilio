require "spec_helper"

describe 'Notifier' do
  describe '#notify' do
    it "sends a POST request to the notification server" do
      RestClient.should_receive :post
      Notifier.notify 'joe'
    end
  end
end