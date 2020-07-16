class OrderMapper < AbstractMapper

  def find(key)
    if key.is_a? Numeric
      abtract_find(Key.new(key))
    else
      abtract_find(key)
    end
  end

  protected

  def find_statement_string
    'SELECT id, customer FROM orders WHERE id = ?'
  end

  def insert_statement_string
    'INSERT INTO orders VALUES(?, ?)'
  end

  def update_statement_string
    'UPDATE orders SET customer = ? WHERE id = ?'
  end

  def delete_statement_string
    'DELETE FROM orders WHERE id = ?'
  end

  def do_load(key, result_set)
    customer = result_set['customer']
    result = Order.new(key, customer)
    MapperRegistry.line_items.load_all_line_items_for(result)
    result
  end

  def insert_data(domain_object_with_key)
    domain_object_with_key.customer
  end

  def load_update_statement(order)
    [order.customer, order.key.value]
  end
end