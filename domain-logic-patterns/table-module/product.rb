# frozen_string_literal: true

require_relative 'product_type'
require_relative 'table_module'

# A representation of the products table
class Product < TableModule
  def initialize(dataset)
    super(dataset, 'products')
  end

  def get_product_type(id)
    product_type = get(id)
    ProductType.const_get(product_type['type'])
  end
end
