require "rspec"

require_relative "../spec_helper"

describe "PostsDAO" do

  it "should insert (and delete) data in database" do
    initial_size = PostsDAO.size()
    post =Post.new("post", "text")
    id = PostsDAO.insert(post)

    PostsDAO.size.should equal (initial_size + 1)

    PostsDAO.delete(nil)
    PostsDAO.delete("")
    PostsDAO.delete("1213")

    PostsDAO.size.should equal (initial_size + 1)

    PostsDAO.delete(id)

    PostsDAO.size.should equal initial_size
  end

  it "should insert (and update) data in database" do
    post =Post.new("post", "text")
    id = PostsDAO.insert(post)

    PostsDAO.update_text(id, "text2")

    expect(PostsDAO.find_post(id).text).to eq("text2")

    PostsDAO.delete(id)

  end

  it "shouldn't insert empty data in database" do
    initial_size = PostsDAO.size()
    PostsDAO.insert(Post.new("", ""))
    PostsDAO.insert(Post.new(nil, nil))
    PostsDAO.insert(nil)

    PostsDAO.size.should equal initial_size
  end

  it "should avoid inserting duplicated posts in database" do
    initial_size = PostsDAO.size()
    post = Post.new("post2", "text2")
    id = PostsDAO.insert(post)

    PostsDAO.size.should equal (initial_size + 1)

    PostsDAO.insert(post)

    PostsDAO.size.should equal (initial_size + 1)

    PostsDAO.delete(id)
  end


  it "should mark post as shared in database" do
    initial_size = PostsDAO.size()
    post =Post.new("post3", "text3")
    id = PostsDAO.insert(post)

    PostsDAO.mark_post_as_shared(id)

    post2 = PostsDAO.find_post(id)

    post2.url.should eq("post3")
    post2.shared.should be true

    PostsDAO.size.should equal (initial_size + 1)

    PostsDAO.delete(id)
  end

  it "should handle invalid values when marking post as shared in database" do
    post =Post.new("post3a", "text3a")
    id = PostsDAO.insert(post)

    PostsDAO.mark_post_as_shared(nil)
    PostsDAO.mark_post_as_shared("")
    PostsDAO.mark_post_as_shared("12312")

    PostsDAO.find_post(nil)
    PostsDAO.find_post("")
    PostsDAO.find_post("12313")

    PostsDAO.delete(id)
  end

  it "should get all posts from database" do
    PostsDAO.deleteAll
    id = PostsDAO.insert(Post.new("post4", "text4"))
    id2 = PostsDAO.insert(Post.new("post5", "text5"))

    posts = PostsDAO.retrieve_all_posts()

    posts.size.should be 2
    posts[0].url.should eq("post5")
    posts[1].url.should eq("post4")

    PostsDAO.delete(id)
    PostsDAO.delete(id2)
  end

  it "should get all unshared posts from database" do
    PostsDAO.deleteAll

    id = PostsDAO.insert(Post.new("post6", "text6"))
    id2 = PostsDAO.insert(Post.new("post7", "text7"))

    PostsDAO.mark_post_as_shared(id)
    posts = PostsDAO.retrieve_unshared_posts()

    posts.size.should be 1
    posts[0].url.should eq("post7")

    PostsDAO.delete(id)
    PostsDAO.delete(id2)
  end
end