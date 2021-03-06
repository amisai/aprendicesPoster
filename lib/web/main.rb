require 'rubygems' if RUBY_VERSION < "1.9"
require 'dotenv'
require 'sinatra/base'

require_relative '../persistence/posts_dao'
require_relative '../job/aprendices_sharer'
require_relative '../job/aprendices_scrapper'
require_relative '../job/rss_generator'

class ApprendicesApp < Sinatra::Base

  configure do
    Dotenv.load
    set :app_file, __FILE__
    set :port, ENV['PORT']
    enable :logging
  end

  helpers do
    def format_links(text)
      text.gsub(/(http[^\s]*)/, '<a href="\1">\1</a>') || text
    end

    def check_security_param
      ENV['KEY']==params[:key]
    end

    def format_bson_as_time(id)
      return id.generation_time
    end
  end

  get '/' do
    if (check_security_param)
      redirect to('/list/')
    end
  end

  get '/list/' do
    if (check_security_param)
      @posts = PostsDAO.retrieve_unshared_posts
      erb :posts
    end
  end

  get '/published/' do
    if (check_security_param)
      @posts = PostsDAO.retrieve_shared_posts
      erb :published
    end
  end

  get '/getPosts/' do
    if (check_security_param)
      AprendicesScrapper.search_new_posts
      redirect to("/list/?key=#{ENV['KEY']}")
    end
  end

  get '/publishPost/' do
    if (check_security_param)
      AprendicesSharer.share_post
      redirect to("/list/?key=#{ENV['KEY']}")
    end
  end

  post '/markPostAsSeen' do
    if (check_security_param)
      PostsDAO.mark_post_as_shared(params[:idMark])
      redirect to("/list/?key=#{ENV['KEY']}")
    end
  end

  post '/markPostAsUnseen' do
    if (check_security_param)
      PostsDAO.mark_post_as_unshared(params[:idMark])
      redirect to("/published/?key=#{ENV['KEY']}")
    end
  end

  post '/publishOnTwitter' do
    if (check_security_param)
      AprendicesSharer.publish_post(params[:idPublish])
      redirect to("/list/?key=#{ENV['KEY']}")
    end
  end

  post '/editTitle' do
    if (check_security_param)
      PostsDAO.update_text(params[:id], params[:title])

      redirect to("/list/?key=#{ENV['KEY']}")
    end
  end

  get '/rss' do
    RSSGenerator.generate_rss
  end

  run! if app_file == $0
end
