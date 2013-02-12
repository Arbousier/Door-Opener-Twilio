require "spec_helper"

describe 'The root' do
  include Rack::Test::Methods

  it "should return an error if token is missing" do
    get '/'
    last_response.should_not be_ok
    last_response.body.should == "error"
  end
  it "should return hello if headers are there" do
    get '/', nil, {'TOKEN' => FIXTURES['tokens'].first}
    last_response.should be_ok
    last_response.body.should == "<h1>Hello world !</h1>"
  end

  it "should return error if token is not right" do
    get '/', nil, {'TOKEN' => "thewrongtoken"}
    last_response.should_not be_ok
    last_response.body.should == "forbidden"
  end

  it "should send back a message if token and phone are ok" do
    post "/phone/#{FIXTURES['authorized_numbers'].first}", nil,
      {'TOKEN' => FIXTURES['tokens'].first}
    last_response.should be_ok
    JSON.parse(last_response.body).should == {"message" => "Hello, Thomas"}
  end

  it "should open the door if token is present and phone is ok" do
    Door.should_receive(:open).once
    post "/phone/#{FIXTURES['authorized_numbers'].first}", nil,
      {'TOKEN' => FIXTURES['tokens'].first}
    last_response.should be_ok
  end
end