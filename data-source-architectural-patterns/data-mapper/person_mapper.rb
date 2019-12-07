# frozen_string_literal: true

require_relative './abstract_mapper'

# A mapper between the people table in the database and the Person domain object
class PersonMapper < AbstractMapper
  TABLE = 'people'
  COLUMNS = 'id, last_name, first_name, number_of_dependents'

  def find(id)
    abstract_find(id, TABLE, COLUMNS)
  end

  def find_by_last_name(last_name)
    find_many(
      sql: <<~SQL,
        SELECT #{COLUMNS}
        FROM #{TABLE}
        WHERE UPPER(last_name) LIKE UPPER(?)
        ORDER BY last_name
      SQL
      parameters: [last_name]
    )
  end

  protected

  def do_load(id, res)
    Person.new(
      id,
      res['last_name'],
      res['first_name'],
      res['number_of_dependents']
    )
  end

  def create_domain_object
    Person.new
  end

  def do_defer_load(person, res)
    person.db_load_last_name(res['last_name'])
    person.first_name = res['first_name']
    person.number_of_dependents = res['number_of_dependents']
  end

  def update_statement
    <<~SQL
      UPDATE #{TABLE}
      SET last_name = ?, first_name = ?, number_of_dependents = ?
      WHERE id = ?
    SQL
  end

  def update_parameters(person)
    [
      person.last_name,
      person.first_name,
      person.number_of_dependents,
      person.id
    ]
  end

  def insert_statement
    "INSERT INTO #{TABLE} VALUES (?, ?, ?)"
  end

  def insert_parameters(person)
    [person.last_name, person.first_name, person.number_of_dependents]
  end
end
