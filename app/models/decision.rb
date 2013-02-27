class Decision < ActiveRecord::Base
  attr_accessible :doc_file, :html, :pdf_file, :promulgated_on
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  before_validation :process_doc, :on => :create

  def process_doc
    if doc_file.present?
      tmp_html_dir = File.join(Rails.root, 'tmp')
      [:pdf, :html].each do |type|
        `/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to #{type} --outdir #{tmp_html_dir} #{self.doc_file.file.path}`
      end
      html_file = File.join(tmp_html_dir, doc_file.file.filename.gsub('.doc', '')+'.html')
      pdf_file = File.join(tmp_html_dir, doc_file.file.filename.gsub('.doc', '')+'.pdf')
      self.html = File.read(html_file)
      self.pdf_file = File.open(pdf_file)
      self.set_text_from_html
    end
  end

  def html_body
    Nokogiri::HTML(self.html).css('body').children.to_html
  end

  def set_text_from_html
    self.text = Nokogiri::HTML(self.html).at_css('body').text
  end
end
