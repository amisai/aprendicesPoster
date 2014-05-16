# encoding: UTF-8


require_relative '../client/aprendices_client'
require_relative '../persistence/posts_dao'

class AprendicesScrapper

  def self.search_new_posts
    posts = AprendicesClient.new().search_new_posts
    posts.each do |post|
      PostsDAO.insert(post)
    end
    puts "Looked for new posts. Now we have #{PostsDAO.size} posts"
  end
end