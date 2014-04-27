# encoding: UTF-8

require 'mongo'

require_relative '../config_loader'

class PostsDAO
  include Mongo


  @@config = ConfigLoader.new.load_config
  # creates a single class instance, sets pool size but won't connect until used (lazy)
  @@client = MongoClient.new('localhost', 27017, :pool_size => 5, :connect => false).db @@config['database']['mongo_database']

  def self.size
    posts = get_collection
    posts.count
  end

  def self.insert(post)
    if (post && post.url && !post.url.empty? && post.text && !post.text.empty?)
      posts = get_collection
      posts.save(post.to_hash) if posts.find({"url" => post.url}).count == 0
    end
  end

  def self.find_post(id)
    post = nil
    posts = get_collection
    begin
      posts.find({"_id" => get_id_as_bson(id)}).each do |doc|
        post = Post.from_hash(doc)
      end
    rescue
      puts("problem while looking for post #{id}")
    end
    post
  end

  def self.retrieve_all_posts
    result = []
    posts = get_collection
    posts.find().sort({"_id" => -1}).each do |doc|
      result << Post.from_hash(doc)
    end
    result
  end

  def self.retrieve_unshared_posts
    result = []
    posts = get_collection
    posts.find({"shared" => false}).sort({"_id" => -1}).each do |doc|
      result << Post.from_hash(doc)
    end
    result
  end

  def self.delete(id)
    posts = get_collection
    begin
      posts.remove({"_id" => get_id_as_bson(id)})
    rescue
      puts("problem while deleting #{id}")
    end
  end

  def self.deleteAll
    posts = get_collection
    posts.remove()
  end

  def self.mark_post_as_shared(id)
    posts = get_collection
    begin
      posts.update({"_id" => get_id_as_bson(id)}, {"$set" => {"shared" => true}})
    rescue
      puts("problem while marking #{id} as shared")
    end
  end

  def self.get_collection
    @@client['posts']
  end

  def self.get_id_as_bson(id)
    if (!id.is_a? BSON::ObjectId)
      BSON::ObjectId.from_string(id)
    else
      id
    end
  end
end
