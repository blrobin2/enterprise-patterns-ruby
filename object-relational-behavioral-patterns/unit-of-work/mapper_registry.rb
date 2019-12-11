# frozen_string_literal: true

# Where all the mappers live
class MapperRegistry
  @mappers = {}

  def self.set_mapper(class_name, mapper)
    @mappers[class_name] = mapper
  end

  def self.get_mapper(class_name)
    @mappers[class_name]
  end
end
