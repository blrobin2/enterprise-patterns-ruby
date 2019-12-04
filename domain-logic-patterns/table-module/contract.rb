# frozen_string_literal: true

require_relative 'table_module'
require_relative 'product'
require_relative 'product_type'

# A representation of the contracts table
class Contract < TableModule
  def initialize(dataset)
    super(dataset, 'contracts')
    @rrev = RevenueRecognition.new(@dataset)
    @product = Product.new(@dataset)
  end

  def calculate_recognition(contract_id)
    amount = get_amount(contract_id)
    product_id = get_product_id(contract_id)
    if @product.get_product_type(product_id) == ProductType::WP
      insert_word_processor(amount, contract_id)
    elsif @product.get_product_type(product_id) == ProductType::SS
      insert_spread_sheet(amount, contract_id)
    elsif @product.get_product_type(product_id) == ProductType::DB
      insert_database(amount, contract_id)
    else raise Exception, 'Invalid product ID'
    end
  end

  private

  def get_amount(contract_id)
    contract_row = get(contract_id)
    contract_row['revenue']
  end

  def insert_word_processor(amount, contract_id)
    @rrev.insert(contract_id, amount, get_date_signed(contract_id))
  end

  def insert_spread_sheet(amount, contract_id)
    now, at60, at90 = amount.allocate(3)
    @rrev.insert(contract_id, now, get_date_signed(contract_id))
    @rrev.insert(contract_id, at60, get_date_signed(contract_id) + 60)
    @rrev.insert(contract_id, at90, get_date_signed(contract_id) + 90)
  end

  def insert_database(amount, contract_id)
    now, at30, at60 = amount.allocate(3)
    @rrev.insert(contract_id, now, get_date_signed(contract_id))
    @rrev.insert(contract_id, at30, get_date_signed(contract_id) + 30)
    @rrev.insert(contract_id, at60, get_date_signed(contract_id) + 60)
  end
end
