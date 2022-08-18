
require_relative "lib/analyser"

if ARGV.size < 1
  STDERR.puts "please provide a file to analyse!"
  STDERR.puts "e.g. /parser.rb filename.log"
  exit 1
end

file_path = ARGV[0]
begin
  file_handle = File.open(file_path, "r")
rescue Errno::ENOENT
  STDERR.puts "file #{file_path} does not exist!"
  STDERR.puts "please provide a valid file to analyse!"
  exit 1
end

analyser = Analyser.new(
  handle: file_handle, 
  output_stream: STDOUT
)

analyser.call