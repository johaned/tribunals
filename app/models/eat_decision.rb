require 'doc_processor'

class EatDecision < ActiveRecord::Base
  has_many :eat_category_decisions
  has_many :eat_subcategories, through: :eat_category_decisions

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :doc_file, PdfFileUploader

  def self.ordered
    order("hearing_date DESC")
  end

  def add_doc
    if doc = Dir.glob(File.join("#{Rails.root}/data/eat/downloads/#{id}", "*.doc")).first
      DocProcessor.add_doc_file(self, File.open(doc))
    end
  end

  def process_doc
    DocProcessor.process_doc_file(self, doc_file) if doc_file.present?
  end

end
