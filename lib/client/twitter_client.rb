# encoding: UTF-8

require 'twitter'
require_relative '../../lib/config_loader'

class TwitterClient
  def initialize()
    config = ConfigLoader.new.load_config
    @client = Twitter.configure do |configTwitter|
      configTwitter.consumer_key = config['twitter']['consumer_key']
      configTwitter.consumer_secret = config['twitter']['consumer_secret']
      configTwitter.oauth_token = config['twitter']['access_token']
      configTwitter.oauth_token_secret = config['twitter']['access_token_secret']
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