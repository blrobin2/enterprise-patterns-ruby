class LineItemMapper < AbstractMapper
  def find(order_id, seq)
    if order_id.instance_of?(Key)
      abstract_find(order_id)
    else
      key = Key.new([order_id, seq])
      abstract_find(key)
    end
  end

  def insert(line_item, order = nil)
    raise Exception 'Must supply an order when inserting a line item' if order.nil?

    key = Key.new(order.key.value, next_sequence_number(order))
    perform_insert(line_item, key)
  end

  def load_all_line_items_for(order)
    result_set = @connection.execute(find_for_order_string, [order.key.value])
    result_set.each do |result_set_item|
      load_with_order(result_set_item, order)
    end
  end

  protected

  def find_statement_string
    'SELECT order_id, seq, amount, product FROM line_items WHERE (order_id = ?) AND (seq = ?)'
  end

  def insert_statement_string
    'INSERT INTO line_items VALUES (?, ?, ?, ?)'
  end

  def update_statement_string
    'UPDATE line_items SET amount = ?, product = ? WHERE order_id = ? AND seq = ?'
  end

  def delete_statement_string
    'DELETE FROM line_items WHERE order_id = ? AND seq = ?'
  end

  def load_find_statement(key)
    [order_id(key), seq(key)]
  end

  def load_with_order(result_set_item, order)
    key = create_key(result_set_item)
    return @loaded_map[key] if @loaded_map.has?(key)

    result = do_load(key, result_set_item, order)
    loaded_map[key] = result
    result
  end

  def do_load(key, result_set, order = nil)
    order ||= MapperRegistry.order.find(order_id(key))
    result = LineItem.new(key, result_set['amount'], result_set['product'])
    order.add_line_item(result)
    result
  end

  def create_key(result_set)
    Key.new([result_set['order_id'], result_set['seq']])
  end

  def insert_key(line_item)
    [order_id(line_item.key), seq(line_item.key)]
  end

  def insert_data(line_item)
    [line_item.amount, line_item.product]
  end

  def load_update_statement(line_item)
    [line_item.amount, line_item.product, order_id(line_item.key), seq(line_item.key)]
  end

  def load_delete_statement(line_item)
    [order_id(line_item.key), seq(line_item.key)]
  end

  private

  def find_for_order_string
    'SELECT order_id, seq, amount, product FROM line_items WHERE order_id = ?'
  end

  def order_id(key)
    key.value(0)
  end

  def seq(key)
    key.value(1)
  end

  def next_sequence_number(order)
    load_all_line_items_for(order)
    item_with_max_key = order.line_items.reject { |item| item.key.nil? }.max_by { seq(item.key) }
    seq(item_with_max_key) + 1
  end
end