class Decision < ActiveRecord::Base
  attr_accessible :doc_file, :html, :pdf_file, :promulgated_on
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader
end
