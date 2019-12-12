# frozen_string_literal: true

# An indentiy map that stores fetched people for caching purposes
class PeopleMap
  def initialize
    @people = {}
  end

  def self.add_person(person)
    # pretend we have a singleton
    sole_instance.people.put(person.id, person)
  end

  def self.get_person(key)
    sole_instance.people.get(key)
  end
end
