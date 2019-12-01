# frozen_string_literal: true

require_relative 'recognition_strategy'
require_relative 'revenue_recognition'

# A revenue recognition strategy where the amount is set up front
class CompleteRecognitionStrategy < RecognitionStrategy
  def calculate_revenue_recognitions(contract)
    contract.add_revenue_recognition(
      RevenueRecognition.new(contract.revenue, contract.when_signed)
    )
  end
end
