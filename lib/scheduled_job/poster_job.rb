require 'sucker_punch'
require 'fist_of_fury'

require_relative '../job/aprendices_sharer'

class ScrapperJob
  include SuckerPunch::Job
  include FistOfFury::Recurrent

  recurs { hourly(2) }

  def perform
    AprendicesSharer.share_post
  end
end