class AbstractMapper
  def initialize(connection)
    @connection = connection
    @loaded_map = {}
  end

  def abstract_find(key)
    result = loaded_map[key]
    return result unless result.nil?

    result_set = @connection.get_first_row(find_statement_string, load_find_statement)
    load(result_set)
  end

  def insert(domain_object_with_key)
    perform_insert(domain_object_with_key, find_next_database_key_object)
  end

  def update(domain_object_with_key)
    statement = @connection.prepare(update_statement_string)
    statement.execute(load_update_statement(domain_object_with_key))
  end

  def delete(domain_object_with_key)
    @connection.execute(delete_statement_string, load_delete_statement(domain_object_with_key))
  end

  protected

  def load_find_statement
    [@key.value]
  end

  def find_statement_string
    raise 'abstract'
  end

  def inert_statement_string
    raise 'abstract'
  end

  def update_statement_string
    raise 'abstract'
  end

  def delete_statement_string
    raise 'abstract'
  end

  def load(result_set)
    key = create_key(result_set)
    return @loaded_map[key] if @loaded_map.has?(key)

    result = do_load(key, result_set)
    @loaded_map[key] = result
    result
  end

  # Default for simple tables
  def create_key(result_set)
    Key.new(result_set['id'])
  end

  def do_load(key, result_set)
    raise 'abstract'
  end

  def perform_insert(domain_object_with_key, key)
    domain_object_with_key.key = key
    statement = @connection.prepare(inert_statement_string)
    statement.execute(insert_key(domain_object_with_key), insert_data(domain_object_with_key))
    @loaded_map[domain_object_with_key.key] = domain_object_with_key
    domain_object_with_key.key
  end

  def insert_key(domain_object_with_key)
    domain_object_with_key.key.value
  end

  def insert_data(domain_object_with_key)
    raise 'abstract'
  end

  def load_update_statement(domain_object_with_key)
    raise 'abstract'
  end

  def load_delete_statement(domain_object_with_key)
    [domain_object_with_key.key.value]
  end
end