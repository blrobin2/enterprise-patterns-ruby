# frozen_string_literal: true

require 'date'
require 'money'
require 'i18n'

I18n.config.available_locales = :en
Money.locale_backend = :i18n

require_relative 'contract'
require_relative 'data_table'
require_relative 'dataset'
require_relative 'revenue_recognition'

# A means of testing the application
class Tester
  def initialize
    initialize_products
    initialize_contracts
    initalize_revenue_recognitions
    initialize_dataset
    calculate_recognitions
  end

  def print
    revenue_recognition = RevenueRecognition.new(@set)
    puts revenue_recognition.recognized_revenue(1, Date.today)
    puts revenue_recognition.recognized_revenue(2, Date.today)
    puts revenue_recognition.recognized_revenue(3, Date.today)
  end

  private

  def initialize_products
    @products = DataTable.new('products')
    @products.add_column('id')
    @products.add_column('name')
    @products.add_column('type')
    @products.add_row(1, 'Thinking Word', 'WP')
    @products.add_row(2, 'Thinking Calc', 'SS')
    @products.add_row(3, 'Thinking DB', 'DB')
  end

  def initialize_contracts
    @contracts = DataTable.new('contracts')
    add_contract_columns
    @contracts.add_row(1, 1, Money.us_dollar(90_00), Date.today.prev_month(1))
    @contracts.add_row(2, 2, Money.us_dollar(10_00), Date.today.prev_month(1))
    @contracts.add_row(3, 3, Money.us_dollar(160_00), Date.today.prev_month(1))
  end

  def initalize_revenue_recognitions
    @revenue_recognitions = DataTable.new('revenue_recognitions')
    @revenue_recognitions.add_column('id')
    @revenue_recognitions.add_column('contract_id')
    @revenue_recognitions.add_column('amount')
    @revenue_recognitions.add_column('recognized_on')
  end

  def initialize_dataset
    @set = Dataset.new('revenue')
    @set.add_table(@products)
    @set.add_table(@contracts)
    @set.add_table(@revenue_recognitions)
  end

  def calculate_recognitions
    contract = Contract.new(@set)
    contract.calculate_recognition(1)
    contract.calculate_recognition(2)
    contract.calculate_recognition(3)
  end

  def add_contract_columns
    @contracts.add_column('id')
    @contracts.add_column('product_id')
    @contracts.add_column('revenue')
    @contracts.add_column('date_signed')
  end
end

Tester.new.print if $PROGRAM_NAME == __FILE__
