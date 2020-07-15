require_relative './product'

# An example of lazy initialization, the simpliest form of lazy loading
class Supplier

  def get_products
    @products ||= Product.find_for_supplier(id)
  end
end

