class CsvParser

  def self.read file, &block
    require 'csv'
    array = []
    index = 0
    CSV.new(file, { headers: true }).each do |row|
      array << [row.to_hash, index += 1]
    end
    array.pmap(&block)
  end
  
end