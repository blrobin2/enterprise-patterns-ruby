# frozen_string_literal: true

require 'money'

# A contract for a given product
class Contract
  attr_reader :revenue, :when_signed

  def initialize(product, revenue, when_signed)
    @product = product
    @revenue = revenue
    @when_signed = when_signed
    @revenue_recognitions = []
  end

  def recognized_revenue(as_of)
    @revenue_recognitions
      .select { |r| r.recognizable_by?(as_of) }
      .inject(Money.us_dollar(0)) { |result, r| result + r.amount }
  end

  def add_revenue_recognition(revenue_recognition)
    @revenue_recognitions << revenue_recognition
  end

  def calculate_recognitions
    @product.calculate_revenue_recognitions(self)
  end
end
