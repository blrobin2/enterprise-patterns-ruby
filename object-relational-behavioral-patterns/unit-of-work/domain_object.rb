# frozen_string_literal: true

require_relative './unit_of_work'

# Any domain object whose state can be tracked
class DomainObject
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def remove
    mark_removed
  end

  protected

  def mark_new
    UnitOfWork.current.register_new(self)
  end

  def mark_clean
    UnitOfWork.current.register_clean(self)
  end

  def mark_dirty
    UnitOfWork.current.register_dirty(self)
  end

  def mark_removed
    UnitOfWork.current.register_removed(self)
  end
end
