# frozen_string_literal: true

class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute; end

  def unexecute; end
end
