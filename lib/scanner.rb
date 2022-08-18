class Scanner
  def initialize(handle)
    @handle = handle
  end

  def each_entry
    handle.each_line do |line|
      path, ip = line.split(" ")
      yield path, ip
    end
  end

  private
  attr_reader :handle
end