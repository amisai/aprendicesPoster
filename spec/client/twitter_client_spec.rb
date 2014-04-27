require 'rspec'

require_relative "../spec_helper"

describe "TwitterClient" do
  it "should publish tweets" do
    msg = "adfagsadglqkjweqer"

    Twitter.should_receive(:update).with(msg).and_return true

    TwitterClient.new().publish msg
  end
end
