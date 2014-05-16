require 'sucker_punch'
require 'fist_of_fury'

require_relative '../job/aprendices_scrapper'

class ScrapperJob
  include SuckerPunch::Job
  include FistOfFury::Recurrent

  def perform
    AprendicesScrapper.search_new_posts
  end
end