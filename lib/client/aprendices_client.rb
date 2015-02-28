require 'nokogiri'
require 'open-uri'

require_relative '../model/post'

class AprendicesClient

  def initialize(url)
    html = open(url)
    @doc = Nokogiri::HTML(html.read)
    @doc.encoding = 'utf-8'
    @banned_types = IO.readlines 'config/banned_types.lst'

    if @banned_types
      @banned_types.map! { |type| type.chomp }
    else
      @banned_types = []
    end

    puts "banned_types:#{@banned_types}"
  end

  def search_new_posts
    posts = []
    articles = @doc.css("div[role='article']")
    puts articles.length
    articles.each_with_index do |article, index|

      url = get_real_link(article)
      text = get_text(article)
      type = get_type(article)

      puts "url.#{url}.text:#{text}"

      if (@banned_types.index(type) == nil)
        posts<<Post.new(url, text, type)
      else
        puts "removing url:#{url}-type:#{type}"
      end
    end
    posts
  end

  def get_type(article)
    begin
      element = get_element(article, "span[class='Wt Hm Ve tr']")
      element.children[0].text ||element.children[0].children[0].text
    rescue
      ''
    end
  end

  def get_intro(article)
    begin
      element = get_element(article, "div[class='Ct']")
      element.children[0].text ||element.children[0].children[0].text
    rescue
      ''
    end
  end

  def get_real_link(article)
    link = ''
    element = get_element(article, "div[class='wI']")
    element = get_element(article, "div[class='yh Du']") if element.empty?
    element = get_element(article, "div[class='rCauNb']") if element.empty?
    element = get_element(article, "div[class='Ct']") if element.empty?
    begin
      link = element.children.select { |child| child.attribute('href') }.first.attribute('href').value
    rescue
      ''
    end
    link
  end

  def get_text(article)
    element1 = get_element(article, "div[class='Ct']")
    element2 = get_element(article, "div[class='wI']")
    element3 = get_element(article, "div[class='yh Du']")

    text1=extract_text(element1)
    text2=extract_text(element2)
    text3=extract_text(element3)

    select_text([text1, text2, text3])
  end

  def select_text(texts)
    texts.select { |text| !text[/http/] }.sort_by { |x| x.length }.last
  end

  def extract_text(element)
    text = ''
    begin
      text = element.children[0].text || element.children[0].children[0].text

      element.children.drop(1).each do |child|
        type = child.name.to_s

        if type == 'text'
          more_text = child.text || child.children[0].text
          text = text + more_text.to_s
        else
          if type == 'a' && child['class'] && (child['class'].include? 'ot-hashtag')
            more_text = child.text
            text = text + more_text.to_s
          end
        end
      end
    rescue
      text = ''
    end
    text
  end

  def get_element(article, selector)
    article.css(selector)
  end
end