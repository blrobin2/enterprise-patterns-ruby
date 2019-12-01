# frozen_string_literal: true

require_relative 'complete_recognition_strategy'
require_relative 'three_way_recognition_strategy'

# A Product that acquires revenue through a recognition strategy
class Product
  def initialize(name, recognition_strategy)
    @name = name
    @recognition_strategy = recognition_strategy
  end

  def calculate_revenue_recognitions(contract)
    @recognition_strategy.calculate_revenue_recognitions(contract)
  end

  def self.new_word_processor(name)
    Product.new(name, CompleteRecognitionStrategy.new)
  end

  def self.new_spreadsheet(name)
    Product.new(name, ThreeWayRecognitionStrategy.new(60, 90))
  end

  def self.new_database(name)
    Product.new(name, ThreeWayRecognitionStrategy.new(30, 60))
  end
end
