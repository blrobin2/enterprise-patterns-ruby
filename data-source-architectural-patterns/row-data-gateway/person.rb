require 'money'

class Person
  def initialize(data)
    @data = data
  end

  def number_of_dependents
    @data.number_of_dependents
  end

  def exemption
    base_exemption = Money.us_dollars(1500)
    dependent_exception = Money.us_dollars(750)
    base_exemption + (dependent_exception * number_of_dependents)
  end
end
