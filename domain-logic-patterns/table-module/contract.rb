require_relative 'table_module'
require_relative 'product'
require_relative 'product_type'

class Contract < TableModule
  def initialize(dataset)
    super(dataset, 'contracts')
  end

  def calculate_recognition(contract_id)
    contract_row = get(contract_id)
    amount = contract_row['revenue']
    revenue_recognition = RevenueRecognition.new(@dataset)
    product = Product.new(@dataset)
    product_id = get_product_id(contract_id)
    if product.get_product_type(product_id) == ProductType::WP
      revenue_recognition.insert(contract_id, amount, get_date_signed(contract_id))
    elsif product.get_product_type(product_id) == ProductType::SS
      now, at60, at90 = amount.allocate(3)
      revenue_recognition.insert(contract_id, now, get_date_signed(contract_id))
      revenue_recognition.insert(contract_id, at60, get_date_signed(contract_id) + 60)
      revenue_recognition.insert(contract_id, at90, get_date_signed(contract_id) + 90)
    elsif product.get_product_type(product_id) == ProductType::DB
      now, at30, at60 = amount.allocate(3)
      revenue_recognition.insert(contract_id, now, get_date_signed(contract_id))
      revenue_recognition.insert(contract_id, at60, get_date_signed(contract_id) + 30)
      revenue_recognition.insert(contract_id, at90, get_date_signed(contract_id) + 60)
    else
      puts product_id
      raise Exception.new("Invalid product ID")
    end
  end
end