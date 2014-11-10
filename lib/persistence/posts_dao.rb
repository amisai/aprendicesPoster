# encoding: UTF-8

require 'mongo'
require 'uri'

class PostsDAO
  include Mongo

  @@db_connection = nil

  def self.get_connection
    return @@db_connection if @@db_connection
=begin

#puts("uri:#{ENV['MONGOHQ_URL']}")
#db = URI.parse(ENV['MONGOHQ_URL'])

    db_host = ENV['MONGODB_PORT_27017_TCP_ADDR']
    db_port = ENV['MONGODB_PORT_27017_TCP_PORT']
    db_name = ENV['MONGODB_DB']

    #db_name = db.path.gsub(/^\//, '')
    @@db_connection = Mongo::Connection.new(db_host, db_port).db(db_name)
    #@@db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)

=end
    puts("uri:#{ENV['MONGOHQ_URL']}")
    db = URI.parse(ENV['MONGOHQ_URL'])
    db_name = db.path.gsub(/^\//, '')
    @@db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @@db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @@db_connection
  end

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

  def self.retrieve_unshared_posts (hours_old = 0)
    result = []
    posts = get_collection

    time = Time.now
    time = time - hours_old * 60 * 60
    time_id = BSON::ObjectId.from_time(time)

    puts "time:#{time}-time_id:#{time_id}"

    posts.find({"shared" => false, '_id' => {'$lte' => time_id}}).sort({"_id" => 1}).each do |doc|
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

  def self.update_text(id, text)
    posts = get_collection
    begin
      posts.update({"_id" => get_id_as_bson(id)}, {"$set" => {"text" => text}})
    rescue
      puts("problem while marking #{id} as shared")
    end
  end

  def self.get_collection
    con = get_connection
    con['posts']
  end

  def self.get_id_as_bson(id)
    if (!id.is_a? BSON::ObjectId)
      BSON::ObjectId.from_string(id)
    else
      id
    end
  end
end
