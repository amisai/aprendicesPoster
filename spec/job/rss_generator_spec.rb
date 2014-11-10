require "rspec"

require_relative '../spec_helper'

describe "RSSGenerator" do

  it "should generate RSS with last 20 posts" do
    PostsDAO.deleteAll
    PostsDAO.insert(Post.new("urlPost1", "text1", "type1"))
    PostsDAO.insert(Post.new("urlPost2", "text2", "type2"))

    result = RSSGenerator.generate_rss

    result.should include("<title>Aprendices Feed</title>")
    result.should include("<link>https://plus.google.com/communities/114859785439968913587</link>")
    result.should include("<description>RSS Feed with posts published in Aprendices community</description>")
    result.should include("<language>en</language>")

    result.should include("<title>text1</title>")
    result.should include("<link>urlPost1</link>")

    result.should include("<title>text2</title>")
    result.should include("<link>urlPost2</link>")
  end
end

