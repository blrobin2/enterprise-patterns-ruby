# frozen_string_literal: true

class Key

  def initialize(fields)
    if !fields.kind_of? Array
      raise ArgumentException 'Cannot have null key' if fields.nil?
      @fields = [fields]
    else
      check_key_not_null(fields)
      @fields = fields
    end
  end

  def ==(obj)
    return false if obj.nil? || !obj.respond_to?(:fields)
    @fields == obj.fields
  end

  def value(index)
    if index.nil?
      check_single_key
      return @fields[0]
    end
    @fields[index]
  end

  private

  def check_key_not_null(fields)
    raise ArgumentException 'Cannot have null key' if fields.nil?
    raise ArgumentException 'Cannot have a null element of key' if fields.any?(&:nil?)
  end

  def check_single_key
    raise Exception 'Cannot take value on composite key' if @fields.size > 1
  end
end