# frozen_string_literal: true

require_relative 'registry'

# A path of writing people to the database
class PersonGateway
  attr_accessor :last_name, :first_name, :number_of_dependents
  attr_reader :id

  def initialize(id, last_name, first_name, number_of_dependents)
    @id = id
    @last_name = last_name
    @first_name = first_name
    @number_of_dependents = number_of_dependents
  end

  def update
    @db.execute(update_statement_string, %i[
                  last_name
                  first_name
                  number_of_dependents
                  id
                ])
  end

  def insert
    @db.execute(insert_statement_string, %i[
                  last_name
                  first_name
                  number_of_dependents
                  id
                ])
  end

  def self.load(res_set)
    result = Registry.get_person(res_set['id'])
    return result if result.present?

    result = PersonGateway.new(
      res_set['id'],
      res_set['last_name'],
      res_set['first_name'],
      res_set['number_of_dependents']
    )
    Registry.add_person(result)
    result
  end

  private

  def update_statement_string
    <<~SQL
      UPDATE people
      SET last_name = ?, first_name = ?, number_of_dependents = ?
      WHERE id = ?
    SQL
  end

  def insert_statement_string
    <<~SQL
      INSERT INTO people VALUES (?, ?, ?)
    SQL
  end
end
