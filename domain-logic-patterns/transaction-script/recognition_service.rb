# frozen_string_literal: true

require 'money'

# Service for storing and fetching recognitions for contracts
class RecognitionService
  def initialize(db)
    @db = db
  end

  def recognized_revenue(contract_number, as_of)
    result = dollars(0)
    @db.find_recognitions_for(contract_number, as_of) do |rs|
      result += dollars(rs['amount'].to_d)
    end
    result
  rescue StandardError
    throw new Exception(
      "Cannot find recognitions for #{contract_number} as of #{as_of}"
    )
  end

  # Alternative: calculate SUM on the DB side, since it's so simple
  def recognized_revenue2(contract_number, as_of)
    result = @db.find_recognized_revenue
    dollars(result.to_d)
  rescue StandardError
    throw new Exception(
      "Cannot find recognitions for #{contract_number} as of #{as_of}"
    )
  end

  def calculate_revenue_recognitions(contract_number)
    contract = @db.find_contract(contract_number)
    throw if contract.nil?
    insert_for_contract_type(
      contract_number,
      dollars(contract['revenue'].to_d),
      Date.parse(contract['date_signed']),
      contract['type']
    )
  rescue StandardError
    throw new Exception("Cannot calculate recognitions for #{contract_number}")
  end

  private

  def dollars(amount)
    Money.new(amount, 'USD')
  end

  def insert_for_contract_type(
    contract_number,
    total_revenue,
    recognition_date,
    type
  )
    case type
    when 'S'
      insert_for_spreadsheet(contract_number, total_revenue, recognition_date)
    when 'W'
      insert_for_word_processor(contract, total_revenue, recognition_date)
    when 'D'
      insert_for_datebase(contract, total_revenue, recognition_date)
    end
  end

  def insert_for_spreadsheet(contract_number, total_revenue, recognition_date)
    now, at60, at90 = total_revenue.allocate(3)
    @db.insert_recognition(contract_number, now, recognition_date)
    @db.insert_recognition(contract_number, at60, recognition_date + 60.days)
    @db.insert_recognition(contract_number, at90, recognition_date + 90.days)
  end

  def insert_for_word_processor(
    contract_number,
    total_revenue,
    recognition_date
  )
    @db.insert_recognition(contract_number, total_revenue, recognition_date)
  end

  def insert_for_datebase(contract_number, total_revenue, recognition_date)
    now, at30, at60 = total_revenue.allocate(3)
    @db.insert_recognition(contract_number, now, recognition_date)
    @db.insert_recognition(contract_number, at30, recognition_date + 30.days)
    @db.insert_recognition(contract_number, at60, recognition_date + 60.days)
  end
end
