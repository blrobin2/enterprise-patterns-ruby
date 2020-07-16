# frozen_string_literal: true

class DomainObjectWithKey
  attr_accessor :key

  protected

  def initialize(key)
    @key = key
  end
end