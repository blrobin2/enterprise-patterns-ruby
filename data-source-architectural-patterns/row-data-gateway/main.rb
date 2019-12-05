require_relative 'person_finder'

finder = PersonFinder.new(SQLite3::Database.open('people.sqlite'))

people = finder.find_responsibles
people.each do |person|
  puts "#{person.last_name} #{person.first_name} #{person.number_of_dependents}\n"
end