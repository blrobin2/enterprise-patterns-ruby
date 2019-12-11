require_relative './album'
require_relative './mapper'

# A pretend mapper
class AlbumMapper < Mapper

  def find(id)
    Album.new(id, '')
  end
end