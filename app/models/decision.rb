class Decision < ActiveRecord::Base
  # attr_accessible :doc_file, :html, :pdf_file, :promulgated_on, :original_filename, :text, :url, :tribunal_id, :reported, :old_details_url
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  has_many :import_errors

  # before_validation :process_doc, :on => :create

  def self.ordered
    order("promulgated_on DESC")
  end

  def self.filtered(filter_hash)
    search(filter_hash[:query]).by_reported(filter_hash[:reported]).by_country_guideline(filter_hash[:country_guideline]).by_country(filter_hash[:country]).by_judge(filter_hash[:judge]).by_claimant(filter_hash[:claimant])
  end

  def self.search(query)
    if query.present?
      where("to_tsvector('english', \"decisions\".\"text\"::text) @@ plainto_tsquery('english', ?::text)", query)
    else
      where("")
    end
  end

  [:country_guideline, :country].each do |field|
    class_eval <<-FILTERS 
      def self.by_#{field}(field)
        if field.present?
          where("#{field} = ?", field)
        else
          where("")
        end
      end
    FILTERS
  end

  def self.by_reported(reported)
    if reported.present? && reported != "all"
      where("reported = ?", reported)
    else
      where("")
    end
  end

  def self.by_judge(judge_name)
    if judge_name.present?
      where("? = ANY (judges)", judge_name)
    else
      where("")
    end
  end

  def self.by_claimant(claimant)
    if claimant.present?
      where("claimant ~ ?", "[[:<:]]#{claimant}[[:>:]]")
    else
      where("")
    end
  end

  def fetch_doc_file
    require 'open-uri'
    self.doc_file = open(URI.parse(URI.encode(self.url)))
  rescue StandardError => e
    self.import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def process_doc
    if doc_file.present?
      tmp_html_dir = File.join(Rails.root, 'tmp')
      [:pdf, :html].each do |type|
        `soffice --headless --convert-to #{type} --outdir #{tmp_html_dir} #{self.doc_file.file.path}`
      end
      html_file = File.join(tmp_html_dir, doc_file.file.filename.gsub('.doc', '')+'.html')
      pdf_file = File.join(tmp_html_dir, doc_file.file.filename.gsub('.doc', '')+'.pdf')
      self.html = File.read(html_file)
      self.pdf_file = File.open(pdf_file)
      self.set_text_from_html
    end
  rescue StandardError => e
    self.import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def html_body
    Nokogiri::HTML(self.html).css('body').children.to_html
  end

  def set_text_from_html
    self.text = Nokogiri::HTML(self.html).at_css('body').text
  end

  def extract_appeal_number
    matches = self.text.match(/Appeal Numbers?: (\w\w[\/ ]\d\d\d\d\d[\/ ]\d\d\d\d)/i)
    if matches
      self.appeal_number = $1.gsub(" ", "/")
    end
  end

  def self.judges_list
    @@judges_list ||= connection.execute("select distinct unnest(judges) as judge from decisions;").collect {|x| x["judge"]}
  end

  def self.country_list
    @@country_list ||= connection.execute("select distinct country as country from decisions;").collect {|x| x["country"]}
  end
end
