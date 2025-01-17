# frozen_string_literal: true

require_relative 'formatter'

class PlainTextFormatter < Formatter
  def output_report(context)
    puts "***** #{context.title} *****"
    context.text.each do |line|
      puts line
    end
  end
end
