class VirtualList
  def initialize(virtual_list_loader)
    @loader = virtual_list_loader
    @source = nil
  end

  def source
    @source ||= @loader.load
  end

  def size
    source.size
  end

  def empty?
    source.empty?
  end
end