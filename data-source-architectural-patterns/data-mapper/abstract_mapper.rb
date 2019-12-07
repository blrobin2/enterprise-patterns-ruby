# frozen_string_literal: true

# A base class for building a mapper between a database table and domain object
class AbstractMapper
  def initialize
    @loaded_map = {}
  end

  def find_many(source)
    res = DB.execute(source[:sql], source[:parameters])
    load_all(res)
  end

  def update(subject)
    DB.execute(update_statement, update_parameters(subject))
  end

  def insert(subject)
    id = DB.execute(insert_statement, insert_parameters(subject))
    @loaded_map[id] = subject
    id
  end

  protected

  def abstract_find(id, table, columns)
    result = @loaded_map[id]
    return result unless result.nil?

    res = DB.get_first_row(find_statement(table, columns), [id])
    load(res)
  end

  def find_statement(table, columns)
    <<~SQL
      SELECT #{columns}
      FROM #{table}
      WHERE id = ?
    SQL
  end

  def load(res)
    id = res['id']
    return @loaded_map[id] if @loaded_map.key?(id)

    result = do_load(id, res)
    @loaded_map[id] = result
    result
  end

  def do_load(_id, _res)
    raise 'Abstract method'
  end

  def defer_load(res)
    id = res['id']
    return @loaded_map[id] if @loaded_map.key?(id)

    result = create_domain_object
    result.id = id
    @loaded_map[id] = result
    do_defer_load(result, res)
    result
  end

  def create_domain_object
    raise 'Abstract method'
  end

  def do_defer_load(_obj, _res)
    raise 'Abstract method'
  end

  def load_all(res)
    result = []
    res.each do |row|
      result << load(row)
    end
  end

  def update_statement
    raise 'Abstract method'
  end

  def update_parameters
    raise 'Abstract method'
  end

  def insert_statement
    raise 'Abstract method'
  end

  def insert_parameters
    raise 'Abstract method'
  end
end
