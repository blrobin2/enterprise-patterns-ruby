# frozen_string_literal: true

class MapperRegistry
  def initialize(connection)
    @connection = connection
  end

  def self.line_item
    @line_item_mapper ||= LineItemMapper.new(@connection)
  end

  def self.order
    @order_mapper ||= OrderMapper.new(@connection)
  end
end
