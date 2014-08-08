require './extract_elements'

ExtractElements.new('data.txt') do |item|
  puts item
end