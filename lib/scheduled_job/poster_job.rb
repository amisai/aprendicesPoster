require 'sucker_punch'
require 'fist_of_fury'

require_relative '../job/aprendices_sharer'

class PosterJob
  include SuckerPunch::Job
  include FistOfFury::Recurrent

  def perform
    puts 'starting PosterJob'
    AprendicesSharer.share_post
  end
end