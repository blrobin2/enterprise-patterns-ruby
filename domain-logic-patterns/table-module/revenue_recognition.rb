# frozen_string_literal: true

require_relative 'table_module'

# A representation of the revenue_recognitions table
class RevenueRecognition < TableModule
  def initialize(dataset)
    super(dataset, 'revenue_recognitions')
  end

  def insert(contract_id, amount, date)
    new_row = @table.new_row
    id = @table.next_id
    new_row['id'] = id
    new_row['contract_id'] = contract_id
    new_row['amount'] = amount
    new_row['date'] = date
    @table.add_new_row(new_row)
    id
  end

  def recognized_revenue(contract_id, as_of)
    rows = @table.select do |row|
      row['contract_id'] == contract_id && row['date'] <= as_of
    end
    result = Money.us_dollar(0)
    rows.each do |row|
      result += row['amount']
    end
    result
  end

  # def recognized_revenue2(contract_id, as_of)
  #   filter = "contract_id = #{contract_id} AND date <= #{as_of}"
  #   computed_expression = "SUM(amount)"
  #   sum = @table.compute(computed_expression, filter)
  #   sum || 0
  # end
end
