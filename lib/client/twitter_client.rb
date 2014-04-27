# encoding: UTF-8

require 'twitter'

class TwitterClient
  def initialize()
    @client = Twitter.configure do |configTwitter|
      configTwitter.consumer_key = ENV['twitter_consumer_key']
      configTwitter.consumer_secret = ENV['twitter_consumer_secret']
      configTwitter.oauth_token = ENV['twitter_access_token']
      configTwitter.oauth_token_secret = ENV['twitter_access_token_secret']
    end
  end

  def publish(message)
    puts("publishing #{message}")
    begin
      Twitter.update(message)
    rescue Exception => e
      puts("found some error while publishing #{message} from twitter:#{e}")
    end
  end
end