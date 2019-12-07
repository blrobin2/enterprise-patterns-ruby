# frozen_string_literal: true

require_relative './domain_object_el'

# A person
class Person < DomainObjectEl
  attr_accessor :id, :last_name, :first_name, :number_of_dependents

  def initialize(
    id = nil,
    last_name = nil,
    first_name = nil,
    number_of_dependents = nil
  )
    @id = id unless id.nil?
    @last_name = last_name unless last_name.nil?
    @first_name = first_name unless first_name.nil?
    return if number_of_dependents.nil?

    @number_of_dependents = number_of_dependents
  end

  def db_load_last_name(last_name)
    assert_state_is_loading
    @last_name = last_name
  end
end
