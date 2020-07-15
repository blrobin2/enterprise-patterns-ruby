require_relative './virtual_list_loader'
require_relative './supplier_vl.rb'

class SupplierMapper

  def do_load(id, result_set)
    result = SupplierVL.new(id, result_set['name'])
    result.products = VirtualList.new(ProductLoader.new(id))
  end

  class ProductLoader < VirtualListLoader
    def initialize(id)
      @id = id
    end

    def load
      ProductMapper.create().find_for_supplier(id)
    end
  end
end