class PersonGateway
  def initialize(conn)
    @conn = conn
  end

  def find_all
    sql = "SELECT * FROM person"
    @conn.execute(sql)
  end

  def find_with_last_name(last_name)
    sql = "SELECT * FROM person WHERE last_name = ?"
    @conn.execute(sql, [last_name])
  end

  def find_where(where_clause)
    sql = "SELECT * FROM person WHERE #{where_clause}"
    @conn.execute(sql)
  end

  def find_row(key)
    sql = "SELECT * FROM person WHERE id = ?"
    @conn.get_first_row(sql, [key])
  end

  def update(key, last_name, first_name, number_of_dependents)
    sql = <<~SQL
      UPDATE person
      SET last_name = ?, first_name = ?, number_of_dependents = ?
      WHERE id = ?
    SQL
    @conn.execute(sql, [last_name, first_name, number_of_dependents, key])
  end

  def insert(last_name, first_name, number_of_dependents)
    sql = "INSERT INTO person VALUES (?,?,?)"
    @conn.execute(sql, [last_name, first_name, number_of_dependents])
    @conn.last_insert_row_id
  end

  def delete(key)
    sql = "DELETE FROM person WHERE id = ?"
    @conn.execute(sql, [key])
  end
end