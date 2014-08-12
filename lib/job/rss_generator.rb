require "rss"

class RSSGenerator

  def self.generate_rss
    posts = PostsDAO.retrieve_all_posts()
    rss = RSS::Maker.make("2.0") do |maker|
      maker.channel.language = "en"
      maker.channel.author = "Aprendices"
      maker.channel.updated = Time.now.to_s
      maker.channel.link = "https://plus.google.com/communities/114859785439968913587"
      maker.channel.title = "Aprendices Feed"
      maker.channel.description = "RSS Feed with posts published in Aprendices community"

      posts.take(ENV['elements_in_rss'].to_i).each do |post|
        maker.items.new_item do |item|
          item.link = post.url
          item.title = post.text
          item.updated = post.id.generation_time.to_s
        end
      end

    end
    rss.to_s
  end
end