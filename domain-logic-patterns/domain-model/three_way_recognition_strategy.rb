# frozen_string_literal: true

require_relative 'recognition_strategy'
require_relative 'revenue_recognition'

# A revenue recognition strategy where the amount is set up front
# and then in two future dates from now, represented as offsets
class ThreeWayRecognitionStrategy < RecognitionStrategy
  def initialize(first_recognition_offset, second_recognition_offset)
    @first_recognition_offset = first_recognition_offset
    @second_recognition_offset = second_recognition_offset
  end

  def calculate_revenue_recognitions(contract)
    now, first_offset, second_offset = contract.revenue.allocate(3)
    add_now(contract, now)
    add_first_offset(contract, first_offset)
    add_second_offset(contract, second_offset)
  end

  private

  def add_now(contract, now)
    contract.add_revenue_recognition(
      RevenueRecognition.new(now, contract.when_signed)
    )
  end

  def add_first_offset(contract, first_offset)
    contract.add_revenue_recognition(
      RevenueRecognition.new(
        first_offset,
        contract.when_signed + @first_recognition_offset
      )
    )
  end

  def add_second_offset(contract, second_offset)
    contract.add_revenue_recognition(
      RevenueRecognition.new(
        second_offset,
        contract.when_signed + @second_recognition_offset
      )
    )
  end
end
