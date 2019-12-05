# frozen_string_literal: true

require_relative 'formatter'

class HtmlFormatter < Formatter
  def output_report(context)
    puts to_html(context)
  end

  private

  def to_html(context)
    <<~HTML
      <html>
        <head>
          <title>#{context.title}</title>
        </head>
        <body>
          #{text_to_html(context.text)}
        </body>
      </html>
    HTML
  end

  def text_to_html(text)
    text.each do |line|
      <<~HTML
        <p>#{line}</p>
      HTML
    end
  end
end
