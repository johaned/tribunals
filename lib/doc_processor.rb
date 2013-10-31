module DocProcessor
  def self.add_doc_file(decision, doc)
    decision.doc_file = doc
    decision.doc_file.store!
    decision.save!
  rescue StandardError => e
    puts e.message
    puts e.backtrace.to_s
  end

  def self.process_doc_file(decision, doc_file)
    Dir.mktmpdir do |tmp_html_dir|
      Dir.chdir(tmp_html_dir) do
        doc_rel_filename = File.basename(doc_file.file.path)
        doc_abs_filename = File.join(tmp_html_dir, doc_rel_filename)
        File.open(doc_abs_filename, 'wb') { |f| f.write(doc_file.sanitized_file.read) }
        [:pdf, "txt:text"].map do |type|
          system("soffice --headless --convert-to #{type} --outdir . '#{doc_rel_filename}'")
        end
        txt_filename = doc_abs_filename.gsub(/\.doc$/i, '.txt')
        pdf_filename = doc_abs_filename.gsub(/\.doc$/i, '.pdf')
        decision.text = File.open(txt_filename, 'r:bom|utf-8').read
        decision.set_html_from_text
        decision.pdf_file = File.open(pdf_filename)
        decision.save!
      end
    end
  rescue StandardError => e
    puts e.message
    puts e.backtrace.to_s
  end
end