require 'csv'
require_relative '../app/models/legislator'

class SunlightLegislatorsImporter
  def self.import
    csv = CSV.new(File.open("db/data/legislators.csv"), {:headers => true, :header_converters => :symbol})
    csv.each do |row|
      Legislator.create!(Hash[row.headers[1..-1].zip(row.fields[1..-1])])
    end
  end
end

begin
  raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
  SunlightLegislatorsImporter.import(ARGV[0])
rescue ArgumentError => e
  $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
rescue NotImplementedError => e
  $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
end
