require_relative "scanner"
require_relative "in_memory_repository"

class Analyser
  def initialize(
    handle:,
    output_stream:,
    scanner_class: Scanner,
    repo_class: InMemoryRepository
  )
    @handle = handle
    @output_stream = output_stream
    @scanner_class = scanner_class
    @repo_class = repo_class
  end

  def call
    scanner.each_entry do |path, ip|
      repo.store(path,ip)
    end

    self.send "display_sort_by", "hits", "uniques"
  end

  private
  attr_reader :handle, :output_stream, :scanner_class, :repo_class

  def scanner
    @scanner ||= scanner_class.new(handle)
  end

  def repo
    @repo ||= repo_class.new
  end

  def display_sort_by(*args)
    args.each do |value|
      output_stream.puts "\n\rPage paths order by #{value}:"
      repo.each_by(value).each do |record|
        output_stream.puts "#{record[:path]} #{record[:"#{value}"]} #{value}"
      end
    end
  end
end