require_relative '../job/aprendices_sharer'

class PosterJob

  def perform
    puts 'starting PosterJob'
    AprendicesSharer.share_post
  end
end