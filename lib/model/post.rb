class Post
  attr_accessor :url, :text, :shared, :id

  def initialize(url, text, shared=false, id=nil)
    @url = url
    @text = text
    @shared = shared
    @id = id
  end

  def ==(another_post)
    if (another_post == nil)
      nil
    else
      self.url == another_post.url && self.text == another_post.text
    end
  end

  def to_hash
    Hash[instance_variables.map { |var| [var[1..-1].to_sym, instance_variable_get(var)] }]
  end


  def self.from_hash(h)
    return Post.new(h['url'], h['text'], h['shared'], h['_id'])
  end
end