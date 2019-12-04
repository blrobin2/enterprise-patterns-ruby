class TableModule
  def initialize(dataset, table_name)
    @dataset = dataset
    @table = dataset.get_table(table_name)
  end

  def get(key)
    res = @table.find(key)
  end

  def method_missing(m, *args, &block)
    # Dynamic get
    attribute = m.to_s.sub('get_', '')
    @table.send(attribute, *args)
  end
end