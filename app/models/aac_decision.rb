class AacDecision < ActiveRecord::Base
  belongs_to :aac_decision_category
  belongs_to :aac_decision_subcategory
  has_many :aac_judgements
  has_many :judges, through: :aac_judgements
  has_many :aac_import_errors

  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader


  def add_doc_file
    if doc = File.open(Dir.glob(File.join("#{Rails.root}/data/aac/docs/j#{id}", "*")).first)
      self.doc_file = doc
      self.doc_file.store!
      self.save!
    end
  rescue StandardError => e
    self.aac_import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def process_doc
    if doc_file.present?
      Dir.mktmpdir do |tmp_html_dir|
        Dir.chdir(tmp_html_dir) do
          doc_rel_filename = File.basename(self.doc_file.file.path)
          doc_abs_filename = File.join(tmp_html_dir, doc_rel_filename)
          File.open(doc_abs_filename, 'wb') { |f| f.write(doc_file.sanitized_file.read) }
          [:pdf, "txt:text"].map do |type|
            system("soffice --headless --convert-to #{type} --outdir . '#{doc_rel_filename}'")
          end
          txt_filename = doc_abs_filename.gsub(/\.doc$/i, '.txt')
          pdf_filename = doc_abs_filename.gsub(/\.doc$/i, '.pdf')
          self.text = File.open(txt_filename, 'r:bom|utf-8').read
          self.set_html_from_text
          self.pdf_file = File.open(pdf_filename)
          self.save!
        end
      end
    end
  rescue StandardError => e
    puts e
    self.aac_import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def set_html_from_text(cache={})
    if self.text
      self.html = self.text.gsub(/\n/, '<br/>')  
      #TODO: check if citation pattern for AAC has same formatting requirement as IAT
    end
  end
end
