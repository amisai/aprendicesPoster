# encoding: UTF-8

require 'net/http'

require_relative '../config_loader'

class KarmacracyClient
  def generate(options)
    config = ConfigLoader.new.load_config
    uri = "http://kcy.me/api/?u=#{config['karmacracy']['username']}&key=#{config['karmacracy']['password']}&url=#{options[:url]}"
    http_response = Net::HTTP.get_response(URI.parse(uri))
    http_response.body
  end
end