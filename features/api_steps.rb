Given /^the API is responding with data in the format we expect$/ do
  #HTTParty.should_receive(:get).and_return(:body => {'token'=> {'guid' => 'usertoken'}}.to_json, :headers => {'Content-Type' => 'application/json'})
end