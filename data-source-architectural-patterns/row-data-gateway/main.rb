# frozen_string_literal: true

require_relative 'person_finder'

finder = PersonFinder.new(SQLite3::Database.open('people.sqlite'))

people = finder.find_responsibles
people.each do |per|
  puts "#{per.last_name} #{per.first_name} #{per.number_of_dependents}\n"
end
