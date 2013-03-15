class Decision < ActiveRecord::Base
  attr_accessible :doc_file, :html, :pdf_file, :promulgated_on, :original_filename, :text
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  has_many :import_errors

  before_validation :process_doc, :on => :create

  def self.ordered
    order("promulgated_on DESC")
  end

  def self.search(query)
    where("(to_tsvector('english', \"decisions\".\"text\"::text) @@ to_tsquery('english', ?::text))", query)
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
    self.import_errors.build(:error => e.message, :backtrace => e.backtrace)
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
end
