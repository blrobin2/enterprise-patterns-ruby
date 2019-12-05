# frozen_string_literal: true

require_relative 'command'

class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
    @contents = File.read(@path)
  end

  def execute
    File.delete(@path)
  end

  def unexecute
    f = File.open(@path, 'w')
    f.write(@contents)
    f.close
  end
end
