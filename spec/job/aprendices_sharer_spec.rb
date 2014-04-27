require "rspec"

require_relative '../spec_helper'

describe "AprendicesSharer" do
  before(:each) do
    ENV['env']='prod'
    ENV['karmacracy_username']='user'
    ENV['karmacracy_password']='password'
    ENV['twitter_consumer_key']='key1'
    ENV['twitter_consumer_secret']='secret'
    ENV['twitter_access_token']='token'
    ENV['twitter_access_token_secret']='secret2'
  end

  it "should share one karmacrazied link through Twitter" do

    post =Post.new("urlPost", "text")
    id = PostsDAO.insert(post)

    Struct.new("Response", :body)
    http_response = Struct::Response.new("kUrl")

    Net::HTTP.stub!(:get_response).and_return http_response

    msg = "From Aprendices: text - kUrl"
    Twitter.should_receive(:update).with(msg).and_return true

    AprendicesSharer.share_post

    PostsDAO.delete(id)
  end

  it "should handle too long texts when sharing links" do
    post =Post.new("link", "123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789I123456789J123456789K123456789L123456789M123456789N123456789O")
    id = PostsDAO.insert(post)

    Struct.new("Response", :body)
    http_response = Struct::Response.new("http://kcy.me/13ajl")

    Net::HTTP.stub!(:get_response).and_return http_response

    msg = "From Aprendices: 123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789I1234... - http://kcy.me/13ajl"
    Twitter.should_receive(:update).with(msg).and_return true

    AprendicesSharer.share_post

    PostsDAO.delete(id)
  end

  it "should handle no posts to share" do
    Twitter.should_receive(:update).exactly(0).times

    AprendicesSharer.share_post

  end
end