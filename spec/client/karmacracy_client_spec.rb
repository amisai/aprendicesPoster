require "rspec"

require_relative '../spec_helper'

describe "KarmacracyClient" do

  it "should generate kcy link" do

    Struct.new("Response", :body)
    http_response = Struct::Response.new("body")

    Net::HTTP.stub!(:get_response).and_return http_response
    expected = "body"

    KarmacracyClient.new().generate({:url => "url1"}).should eql expected
  end
end
