# frozen_string_literal: true

require_relative './domain_object'

# An Album
class Album < DomainObject
  def initialize(id, name)
    @name = name
    super(id)
  end

  attr_reader :name

  def name=(name)
    @name = name
    self.mark_dirty
  end

  def self.create(name)
    obj = Album.new('id', name)
    obj.mark_new
    obj
  end
end
