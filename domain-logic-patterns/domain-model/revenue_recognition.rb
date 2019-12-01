# frozen_string_literal: true

# Revenue that can be counted as such at a certain date
class RevenueRecognition
  attr_reader :amount

  def initialize(amount, date)
    @amount = amount
    @date = date
  end

  def recognizable_by?(as_of)
    as_of >= @date
  end
end
