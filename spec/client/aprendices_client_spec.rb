require "rspec"


require_relative "../spec_helper"

describe "AprendicesClient" do

  it "should parse Aprendices page and extract information" do

    html_content = File.open(File.dirname(__FILE__) + '/../fixtures/aprendices_22_05_2014.html').read

    AprendicesClient.any_instance.stub(:open).and_return html_content

    posts = AprendicesClient.new('url').search_new_posts

    posts.should have_at_least(1).items
  end

end