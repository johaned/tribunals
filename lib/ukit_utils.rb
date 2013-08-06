module UkitUtils
  AN_REGEX = /[A-Z]{2}\d{9}/
  AN_FORMATTED_REGEX = /[A-Z]{2}\/\d{5}\/\d{4}/
  AN_CAPTURING_REGEX = /([A-Z]{2})(\d{5})(\d{4})/
  NCN_REGEX = /\[\d{4}\] UK[A-Z]+ \d+/

  def self.appeal_numbers_from_filename(filename)
    File.basename(filename.upcase, '.DOC').gsub(/[^A-Z0-9]/, '').scan(AN_REGEX)
  end

  def self.format_appeal_number(string)
    if m = AN_CAPTURING_REGEX.match(string)
      m.captures.join('/')
    else
      string
    end
  end

  def self.contains_ncn?(string)
    string.scan(NCN_REGEX).first
  end

  def self.contains_appeal_number?(string)
    string.scan(AN_FORMATTED_REGEX).first
  end
end
