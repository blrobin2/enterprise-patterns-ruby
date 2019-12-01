# frozen_string_literal: true

# A representation of calculating revenue recognition
class RecognitionStrategy
  def calculate_revenue_recognitions(_contract)
    throw 'Abstract class'
  end
end
