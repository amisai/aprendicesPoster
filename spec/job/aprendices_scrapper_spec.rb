require "rspec"

require_relative "../spec_helper"

describe "AprendicesScrapper" do
  it "should fill database with some posts information" do

    html_content = File.open(File.dirname(__FILE__) + '/../fixtures/aprendices_20_04_2014.html').read

    AprendicesClient.any_instance.stub(:open).and_return html_content

    AprendicesScrapper.search_new_posts

    PostsDAO.retrieve_unshared_posts.count.should be 19

    PostsDAO.deleteAll
  end
end