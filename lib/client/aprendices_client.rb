require 'nokogiri'
require 'open-uri'

require_relative '../model/post'

class AprendicesClient
  @@url = 'https://plus.google.com/communities/114859785439968913587'

  def initialize
    @doc = Nokogiri::HTML(open(@@url))
  end

  def search_new_posts()
    posts = []
    articles = @doc.css("div[role='article']")
    puts articles.length
    articles.each do |article|
      intro = get_intro(article)
      url = get_real_link(article)
      text = get_text(article)

      posts<<Post.new(url, text)
    end
    posts
  end

  def get_intro(article)
    begin
      article.css("div[class='Ct']").children[0].text ||article.css("div[class='Ct']").children[0].children[0].text
    rescue
      ''
    end
  end

  def get_real_link(article)
    element = article.css("div[class='wI']")
    element = article.css("div[class='yh Du']") if element.empty?
    element = article.css("div[class='rCauNb']") if element.empty?
    begin
      element.children[0].attribute('href').value
    rescue
      ''
    end
  end

  def get_text(article)
    element = article.css("div[class='wI']")
    element = article.css("div[class='yh Du']") if element.empty?
    begin
      element.children[0].text || element.children[0].children[0].text
    rescue
      ''
    end
  end
end