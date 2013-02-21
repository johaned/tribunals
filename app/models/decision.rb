class Decision < ActiveRecord::Base
  attr_accessible :doc_file, :html, :pdf_file, :promulgated_on
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  before_create :process_doc

  def process_doc
    tmp_html_dir = File.join(Rails.root, 'tmp')
    `/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to html --outdir #{tmp_html_dir} #{self.doc_file.file.path}`
    html_file = File.join(tmp_html_dir, doc_file.file.filename.gsub('.doc', '.html'))
    self.html = File.read(html_file)
  end
end
