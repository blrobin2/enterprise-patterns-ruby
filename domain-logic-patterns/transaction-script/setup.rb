# frozen_string_literal: true

require 'sqlite3'

DBNAME = 'revenue.sqlite'
File.delete(DBNAME) if File.exist? DBNAME

create_tables = File.read('migration.sql').split("\n")

DB = SQLite3::Database.new DBNAME
create_tables.each do |create_table|
  puts create_table
  DB.execute(create_table)
end
