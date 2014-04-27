# encoding: UTF-8

require 'yaml'

class ConfigLoader
  def initialize()
    @properties_file = '../../config/poster.properties'
  end


  def load_config ()
    YAML.load_file(File.expand_path(@properties_file, __FILE__))
  end
end
