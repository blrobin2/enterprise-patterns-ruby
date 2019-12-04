# frozen_string_literal: true

# A representation of a collection of tables, or a database
class Dataset
  def initialize(db_name)
    @db_name = db_name
    @tables = {}
  end

  def add_table(data_table)
    @tables[data_table.table_name] = data_table
  end

  def get_table(table_name)
    @tables[table_name]
  end
end
