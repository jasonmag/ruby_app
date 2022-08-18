
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

    output_stream.puts "Page paths ordered by hits:"
    repo.each_by_hits.each do |record|
      output_stream.puts "#{record[:path]} #{record[:uniques]} uniques"
    end
  end

  private
  attr_reader :handle, :output_stream, :scanner_class, :repo_class

  def scanner
    @scanner ||= scanner_class.new(handle)
  end

  def repo
    @repo ||= repo_class.new
  end
end