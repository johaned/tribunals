require 'doc_processor'

class FttDecision < ActiveRecord::Base
  has_many :ftt_subcategories_decisions
  has_many :ftt_subcategories, through: :ftt_subcategories_decisions
  has_many :ftt_judgments
  has_many :ftt_judges, through: :ftt_judgments

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  def self.ordered
    order("decision_date DESC")
  end

  def self.filtered(filter_hash)
    search(filter_hash[:query])
  end

  def self.search(query)
    if query.present?
      quoted_query = self.connection.quote(query)
      where("to_tsvector('english', text::text) @@ plainto_tsquery('english', ?::text)", query).order("text ~* #{quoted_query} DESC")
    else
      where("")
    end
  end

  def add_doc
    if doc = Dir.glob(File.join("#{Rails.root}/data/ftt/docs/j#{id}", "*.doc")).first
      DocProcessor.add_doc_file(self, File.open(doc))
    end
  end

  def process_doc
    DocProcessor.process_doc_file(self, doc_file) if doc_file.present?
  end

  def set_html_from_text(cache={})
    if self.text
      self.html = self.text.gsub(/\n/, '<br/>')  
      #TODO: check if citation pattern for FTT has same formatting requirement as IAT
    end
  end
end
