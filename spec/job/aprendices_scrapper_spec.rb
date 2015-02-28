require "rspec"

require_relative "../spec_helper"

describe "AprendicesScrapper" do
  it "should fill database with some posts information" do
    PostsDAO.deleteAll

    html_content = File.open(File.dirname(__FILE__) + '/../fixtures/aprendices_20_04_2014.html')

    AprendicesClient.any_instance.stub(:open).and_return html_content

    AprendicesScrapper.search_new_posts

    posts = PostsDAO.retrieve_unshared_posts -1

    posts[0].text.should eq 'The SOLID Design Principles Deconstructed by Kevlin Henney - YOW! 2013 | Eventer'

    posts.count.should be 15

    PostsDAO.deleteAll
  end

  it "should handle hashtags in title" do
    PostsDAO.deleteAll

    html_content = File.open(File.dirname(__FILE__) + '/../fixtures/aprendices_19_02_2015.html')

    AprendicesClient.any_instance.stub(:open).and_return html_content

    AprendicesScrapper.search_new_posts

    posts = PostsDAO.retrieve_unshared_posts -1

    posts.count.should be 12

    posts[2].text.include?('Stages of #TDD, Jay Bazuzi').should be true


    PostsDAO.deleteAll
  end
end