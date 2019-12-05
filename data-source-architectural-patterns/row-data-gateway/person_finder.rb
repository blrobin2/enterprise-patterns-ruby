# frozen_string_literal: true

require_relative 'person_gateway'
require_relative 'registry'

# A means of looking up people
class PersonFinder
  def initialize(db)
    @db = db
  end

  def find(id)
    result = Registry.get_person(id)
    return result if result.present?

    rs = @db.get_first_row(find_statement_string, [id])
    PersonGateway.load(rs)
  end

  def find_responsibles
    rs = @db.execute(find_responsible_string)
    result = []
    rs.each do |row|
      result << PersonGateway.load(row)
    end
    result
  end

  private

  def find_statement_string
    <<~SQL
      SELECT id, last_name, first_name, number_of_dependents
      FROM people
      WHERE id = ?
    SQL
  end

  def find_responsible_string
    <<~SQL
      SELECT id, last_name, first_name, number_of_dependents
      FROM people
      WHERE number_of_dependents > 0
    SQL
  end
end
