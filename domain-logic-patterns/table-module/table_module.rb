# frozen_string_literal: true

# A base class for representations of tables that separates the Data*
# from the modules
class TableModule
  def initialize(dataset, table_name)
    @dataset = dataset
    @table = dataset.get_table(table_name)
  end

  def get(key)
    @table.find(key)
  end

  def method_missing(method_name, *args)
    attribute = method_name.to_s.sub('get_', '')
    if @table.respond_to?(attribute)
      @table.send(attribute, *args)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    attribute = m.to_s.sub('get_', '')
    @table.respond_to_missing?(attribute) || super
  end
end
