# frozen_string_literal: true

require 'date'
require 'i18n'
require 'money'

require_relative 'contract'
require_relative 'product'

I18n.config.available_locales = :en
Money.locale_backend = :i18n

# A way to test the revenue recognition logic
class Tester
  def initialize
    @word_contract = word_contract
    @calc_contract = calc_contract
    @db_contract = db_contract
  end

  def word_contract
    Contract.new(
      Product.new_word_processor('Thinking Word'),
      Money.us_dollar(9000),
      Date.today.prev_month(1)
    )
  end

  def calc_contract
    Contract.new(
      Product.new_spreadsheet('Thinking Calc'),
      Money.us_dollar(1000),
      Date.today.prev_month(1)
    )
  end

  def db_contract
    Contract.new(
      Product.new_database('Thinking DB'),
      Money.us_dollar(16_000),
      Date.today.prev_month(1)
    )
  end

  def calculate_recognitions
    # Same interface, no knowledge of stategies
    @word_contract.calculate_recognitions
    @calc_contract.calculate_recognitions
    @db_contract.calculate_recognitions
    self
  end

  def print
    puts @word_contract.recognized_revenue(Date.today)
    puts @calc_contract.recognized_revenue(Date.today)
    puts @db_contract.recognized_revenue(Date.today)
  end
end

Tester.new.calculate_recognitions.print if $PROGRAM_NAME == __FILE__
