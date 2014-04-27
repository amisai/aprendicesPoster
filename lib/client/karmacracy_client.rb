# encoding: UTF-8

require 'net/http'

class KarmacracyClient
  def generate(options)
    uri = "http://kcy.me/api/?u=#{ENV['karmacracy_username']}&key=#{ENV['karmacracy_password']}&url=#{options[:url]}"
    http_response = Net::HTTP.get_response(URI.parse(uri))
    http_response.body
  end
end