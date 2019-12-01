# frozen_string_literal: true

# Gateway between database and application services
class Gateway
  def initialize(connection)
    @connection = connection
  end

  def find_recognitions_for(contract_id, as_of)
    @connection.execute(self.class.find_recognitions_statement, [
                          contract_id,
                          as_of.to_s
                        ])
  end

  def find_recognized_revenue(contract_id, as_of)
    @connection.get_first_value(self.class.find_recognized_revenue_statement, [
                                  contract_id,
                                  as_of.to_s
                                ])
  end

  def find_contract(contract_id)
    @connection.get_first_row(self.class.find_contract_statement, [contract_id])
  end

  def insert_recognition(contract_id, amount, as_of)
    @connection.execute(self.class.insert_recognition_statement, [
                          contract_id,
                          amount.amount,
                          as_of.to_s
                        ])
  end

  def self.find_recognitions_statement
    <<~SQL
      SELECT amount
      FROM revenue_recognitions
      WHERE contract = ? AND recognized_on = ?
    SQL
  end

  def self.find_recognized_revenue_statement
    <<~SQL
      SELECT SUM(amount)
      FROM revenue_recognitions
      WHERE contract = ? AND recognized_on = ?
    SQL
  end

  def self.find_contract_statement
    <<~SQL
      SELECT *
      FROM contracts c
      JOIN products p ON c.product = p.id
      WHERE c.id = ?
    SQL
  end

  def self.insert_recognition_statement
    'INSERT INTO revenue_recognition VALUE (?, ?, ?)'
  end
end
