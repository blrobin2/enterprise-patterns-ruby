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
    obj = Hash[@columns.map.with_index { |x, i| [x, row[i] ] }]
    @data << obj
  end

  def new_row
    Hash[@columns.collect { |x| [x, nil ] }]
  end

  def add_new_row(row)
    @data << row
  end

  def get_next_id
    @data.length
  end

  def find(key)
    @data.find { |row| row['id'] == key }
  end

  def select(&block)
    @data.select(&block)
  end

  # Dynamic attribute fetcher
  def method_missing(m, *args, &block)
    column = m.to_s
    return unless @columns.include?(column)
    res = find(args[0])
    res[column]
  end
end