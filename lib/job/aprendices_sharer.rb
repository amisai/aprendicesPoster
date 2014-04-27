# encoding: UTF-8

require_relative '../client/aprendices_client'
require_relative '../persistence/posts_dao'
require_relative '../client/twitter_client'
require_relative '../client/karmacracy_client'

class AprendicesSharer

  def self.share_post()
    archive = ENV['env'] == 'prod'

    puts 'Starting. First we get url from unshared posts:'
    bookmark = PostsDAO.retrieve_unshared_posts()[0] || ""

    if "" != bookmark
      puts("bookmark:#{bookmark}")
      uri = bookmark.url
      puts "returned uri:#{uri}"
      puts "now we're invoking karmacracy"

      url = KarmacracyClient.new().generate({:url => uri})
      puts "Karmacracy uri:#{url}"

      puts "and now, we create message to share"
      title = bookmark.text
      message = "From Aprendices: #{title}"
      l = 130 - url.size
      if message.length > l
        message = message.slice(0, l) + "..."
      end

      message = "#{message} - #{url}"
      puts "msg:#{message}.size:#{message.size}.archive:#{archive}"
      TwitterClient.new().publish(message) if archive
      PostsDAO.mark_post_as_shared(bookmark.id) if archive
      message
    end
  end
end