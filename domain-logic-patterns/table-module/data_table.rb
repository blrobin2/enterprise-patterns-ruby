# frozen_string_literal: true

# A representation of a table in a database
class DataTable
  attr_reader :table_name, :data

  def initialize(table_name)
    @table_name = table_name
    @columns = []
    @data = []
  end

  def add_column(column_name)
    @columns << column_name
  end

  def add_row(*row)
    obj = Hash[@columns.map.with_index { |x, i| [x, row[i]] }]
    @data << obj
  end

  def new_row
    Hash[@columns.collect { |x| [x, nil] }]
  end

  def add_new_row(row)
    @data << row
  end

  def next_id
    @data.length
  end

  def find(key)
    @data.find { |row| row['id'] == key }
  end

  def select(&block)
    @data.select(&block)
  end

  # Dynamic attribute fetcher
  def method_missing(method_name, *args)
    if respond_to_missing?(method_name)
      column = method_name.to_s
      res = find(args[0])
      res[column]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @columns.include?(method_name.to_s) || super
  end
end
