require_relative 'product_type'
require_relative 'table_module'

class Product < TableModule

  def initialize(dataset)
    super(dataset, 'products')
  end

  def get_product_type(id)
    product_type = get(id)
    return ProductType.const_get(product_type['type'])
  end
end