class Decision < ActiveRecord::Base
  mount_uploader :doc_file, DocFileUploader
  mount_uploader :pdf_file, PdfFileUploader

  validates_presence_of :doc_file, :appeal_number
  validates_inclusion_of :reported, in: [true, false]
  validates_inclusion_of :country_guideline, in: [true, false], if: :reported
  validates_presence_of :country, :claimant, :promulgated_on, if: :reported
  validates_length_of :judges, minimum: 1, if: :reported

  has_many :import_errors

  scope :viewable, ->{ where("reported = 't' OR promulgated_on >= ?", Date.new(2013, 6, 1)) }

  def self.ordered
    order("promulgated_on DESC")
  end

  def self.filtered(filter_hash)
    search(filter_hash[:query]).by_reported(filter_hash[:reported]).by_country_guideline(filter_hash[:country_guideline]).by_country(filter_hash[:country]).by_judge(filter_hash[:judge]).by_claimant(filter_hash[:claimant]).by_ncn(filter_hash[:ncn])
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
      where("claimant ~* ?", Regexp.quote(claimant))
    else
      where("")
    end
  end

  def self.by_ncn(ncn)
    if ncn.present?
      where("appeal_number ~* ?", Regexp.quote(ncn))
    else
      where("")
    end
  end

  def label
    if reported
      [appeal_number, case_name].join(' - ')
    end
  end

  def fetch_doc_file
    self.doc_file.download!(URI.parse(URI.encode(self.url)).to_s)
    self.doc_file.store!
    self.save!
  rescue StandardError => e
    self.import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def process_doc
    require 'thwait'
    if doc_file.present?
      Dir.mktmpdir do |tmp_html_dir|
        doc_filename = File.join(tmp_html_dir, File.basename(self.doc_file.file.path))
        File.open(doc_filename, 'wb') do |f|
          f.write(doc_file.read)
        end
        threads = [:pdf, "txt:text"].map do |type|
          Thread.new do
            command = "soffice --headless --convert-to #{type} --outdir #{tmp_html_dir} '#{doc_filename}'"
            puts command
            method(:`).call(command)
          end
        end
        ThreadsWait.all_waits(*threads)
        txt_filename = doc_filename.gsub(/\.doc$/i, '.txt')
        pdf_filename = doc_filename.gsub(/\.doc$/i, '.pdf')
        self.text = File.open(txt_filename, 'r:bom|utf-8').read
        self.set_html_from_text
        self.pdf_file = File.open(pdf_filename)
        self.save!
      end
    end
  rescue StandardError => e
    puts e
    self.import_errors.create!(:error => e.message, :backtrace => e.backtrace.to_s)
  end

  def set_html_from_text(cache={})
    if self.text
      # line breaks
      self.html = self.text.gsub(/\n/, '<br/>')
  
      # references to other decisions
      citation_pattern = /\[[0-9]{4}\]\s*[0-9]*\s+[A-Z]+\s*[A-Za-z\.]*\s*[0-9]*/ # (see http://ox.libguides.com/content.php?pid=141334&sid=1205598)
  
      self.html = self.html.gsub(citation_pattern) do |citation|
        normalised_citation = citation.gsub(/\s+0+([1-9])/, ' \1')
        decision = cache[normalised_citation] || Decision.find_by(appeal_number: normalised_citation) || (next citation)
        decision_url = Tribunals::Application.routes.url_helpers.decision_path(decision)
        "<a href='"+decision_url+"'>"+citation+"</a>"
      end
    end
  end

  def extract_appeal_number
    matches = self.text.match(/Appeal\sNumbers?:\s(\w\w[\/ ]\d\d\d\d\d[\/ ]\d\d\d\d)/i)
    if matches
      self.appeal_number = $1.gsub(" ", "/")
    end
  end

  def self.judges_list
    order('judge ASC').pluck("DISTINCT UNNEST(judges) AS judge")
  end

  def self.country_list
    order('country ASC').pluck("DISTINCT country")
  end
end
