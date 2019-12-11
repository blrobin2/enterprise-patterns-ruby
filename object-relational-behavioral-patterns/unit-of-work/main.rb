# frozen_string_literal: true

require_relative './unit_of_work'
require_relative './mapper_registry'
require_relative './album_mapper'
require_relative './album'

# Testing
class Main

  def self.setup
    MapperRegistry.set_mapper(Album.name, AlbumMapper.new)
  end

  def self.update_album_name(album_id, name)
    UnitOfWork.new_current
    mapper = MapperRegistry.get_mapper(Album.name)
    album = mapper.find(album_id)
    album.name = name
    UnitOfWork.current.commit
  end
end

Main.setup
Main.update_album_name(1, 'Carl')
