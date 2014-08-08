require 'json'

# Yield a result as we work through a file.
class ExtractElements
  PRICE_PATTERN     = / \d{0,6}(\.\d{1,2})/ #space at front forces 2nd price to match
  DATE_PATTERN      = / \d{2}\/\d{2} . \d{2}\/\d{2}/ # grab two four digit years, and what's between
  # Match initial price & inital date, but don't capture, grab everything in between
  FEATURE_PATTERN   = (/(?<=\d ).*?(?= \d{2}\/)/)

  def initialize(file)
    file = open('data.txt') # STDIN Could be a fun way to do this too
    file.each do |line|
      hash = {}
      hash['feature']     = extract_feature(line)
      hash['date_range']  = extract_date_range(line)
      hash['price']       = extract_price(line)
      yield hash.to_json
    end
  end

  private

  def extract_price(line)
    match   = line.match(PRICE_PATTERN)
    return nil if match.nil?
    return match[0].strip
  end

  def extract_date_range(line)
    match = line.match(DATE_PATTERN)
    return nil if match.nil?
    return match[0].strip
  end

  def extract_feature(line)
    match = line.match(FEATURE_PATTERN)
    return nil if match.nil?
    return match[0].strip
  end
end
