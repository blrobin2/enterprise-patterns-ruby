# frozen_string_literal: true

# A means of mapping object actions into database actions
class Mapper
  def insert(domain_object)
    # Inserts the object in the database
  end

  def update(domain_object)
    # Updates the object in the database
    puts "Album updated!"
  end

  def find(id)
    # Finds an object by its ID
  end
end
