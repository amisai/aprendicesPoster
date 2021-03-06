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

    post =Post.new("urlPost", "text", "type")
    id = PostsDAO.insert(post)

    Struct.new("Response", :body)
    http_response = Struct::Response.new("kUrl")

    Net::HTTP.stub!(:get_response).and_return http_response

    msg = "From Aprendices: text - kUrl"
    Twitter.should_receive(:update).with(msg).and_return true

    AprendicesSharer.share_post -1

    PostsDAO.delete(id)
  end

  it "should post selected link through Twitter" do

    post =Post.new("urlPost2", "text2", "type2")
    id = PostsDAO.insert(post)

    Struct.new("Response", :body)
    http_response = Struct::Response.new("kUrl2")

    Net::HTTP.stub!(:get_response).and_return http_response

    msg = "From Aprendices: text2 - kUrl2"
    Twitter.should_receive(:update).with(msg).and_return true

    AprendicesSharer.publish_post(id)

    PostsDAO.delete(id)
  end

  it "should handle too long texts when sharing links" do
    post =Post.new("link", "123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789I123456789J123456789K123456789L123456789M123456789N123456789O", "type3")
    id = PostsDAO.insert(post)

    Struct.new("Response", :body)
    http_response = Struct::Response.new("http://kcy.me/13ajl")

    Net::HTTP.stub!(:get_response).and_return http_response

    msg = "From Aprendices: 123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789I1234... - http://kcy.me/13ajl"
    Twitter.should_receive(:update).with(msg).and_return true

    AprendicesSharer.share_post -1

    PostsDAO.delete(id)
  end

  it "should handle no posts to share" do
    Twitter.should_receive(:update).exactly(0).times

    AprendicesSharer.share_post

  end
end