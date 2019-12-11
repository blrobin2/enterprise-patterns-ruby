# frozen_string_literal: true

require_relative './mapper_registry'

# A thread-safe means of registering changes on objects
class UnitOfWork
  @current = Thread.current

  def self.new_current
    set_current(UnitOfWork.new)
  end

  def self.set_current(unit_of_work)
    @current[:unit_of_work] = unit_of_work
  end

  def self.current
    @current[:unit_of_work]
  end

  def initialize
    @new_objects = []
    @dirty_objects = []
    @removed_objects = []
  end

  def register_new(domain_object)
    raise 'ID is null' if domain_object.id.nil?
    raise 'Object is dirty' if @dirty_objects.include?(domain_object)
    raise 'Object removed' if @removed_objects.include?(domain_object)
    if @new_objects.include?(domain_object)
      raise 'Object already registered new'
    end

    @new_objects << domain_object
  end

  def register_dirty(domain_object)
    raise 'ID is null' if domain_object.id.nil?
    raise 'Object removed' if @removed_objects.include?(domain_object)

    return unless not_diry_or_new?(domain_object)

    @dirty_objects << domain_object
  end

  def register_removed(domain_object)
    raise 'ID is null' if domain_object.id.nil?
    return if @new_objects.delete(domain_object)

    @dirty_objects.delete(domain_object)
    return if @removed_objects.include?(domain_object)

    @removed_objects << domain_object
  end

  def register_clean(domain_object)
    raise 'ID is null' if domain_object.id.nil?
  end

  def commit
    insert_new
    update_dirty
    delete_removed
  end

  private

  def insert_new
    @new_objects.each do |domain_object|
      MapperRegistry.get_mapper(domain_object.class.name).insert(domain_object)
    end
  end

  def update_dirty
    @dirty_objects.each do |domain_object|
      MapperRegistry.get_mapper(domain_object.class.name).update(domain_object)
    end
  end

  def delete_removed
    @removed_objects.each do |domain_object|
      MapperRegistry.get_mapper(domain_object.class.name).delete(domain_object)
    end
  end

  def not_diry_or_new?(obj)
    !@dirty_objects.include?(obj) && !@new_objects.include?(obj)
  end
end
