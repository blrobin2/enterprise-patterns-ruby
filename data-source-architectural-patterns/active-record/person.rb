# frozen_string_literal: true

require 'money'

# A representation of the people table and the associated domain logic
class Person
  att_reader :last_name, :first_name, :number_of_dependents

  def initialize(id, last_name, first_name, number_of_dependents)
    @id = id
    @last_name = last_name
    @first_name = first_name
    @number_of_dependents = number_of_dependents
  end

  def self.find(id)
    result = Registry.get_person(id)
    return result unless result.nil?

    res = DB.get_first_row(find_statement_string, [id])
    load(res)
  end

  def self.load(res)
    result = Registry.get_person(res.id)
    return result unless result.nil?

    result = Person.new(
      res.id,
      res.last_name,
      res.first_name,
      res.number_of_dependents
    )
    Registry.add_person(result)
    result
  end

  def update
    DB.execute(update_statement_string, [
                 @last_name,
                 @first_name,
                 @number_of_dependents,
                 @id
               ])
  end

  def insert
    DB.execute(insert_statement_string, [
                 @id,
                 @last_name,
                 @first_name,
                 @number_of_dependents
               ])
    Registry.add_person(self)
  end

  def exemption
    base_exemption = Money.us_dollars(1500)
    dependent_exemption = Money.us_dollars(750)
    base_exemption + (dependent_exemption * @number_of_dependents)
  end

  private

  def self.find_statement_string
    <<~SQL
      SELECT id, last_name, first_name, number_of_dependents
      FROM people
      WHERE id = ?
    SQL
  end

  def update_statement_string
    <<~SQL
      UPDATE people
      SET last_name = ?, first_name = ?, number_of_dependents = ?
      WHERE id = ?
    SQL
  end

  def insert_statement_string
    <<~SQL
      INSERT INTO people VALUES (?, ?, ?, ?)
    SQL
  end

  private_class_method :find_statement_string
end
