require 'spec_helper'

describe AacDecision do
  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @decision.doc_file.file.instance_variable_set(:@file, nil)
        @decision.process_doc
      end

      after(:all) do
        @decision.destroy
        File.unlink(File.join(Rails.root, 'tmp', 'test.html'))
        File.unlink(File.join(Rails.root, 'tmp', 'test.pdf'))
      end

      it "should save a tmp html file" do
        @decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @decision.text.should == "Test\n"
      end
    end

    it "should still save if the doc processing fails" do
      @decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(__FILE__)))
      File.should_receive(:open).and_raise(StandardError)
      expect {
        @decision.process_doc
      }.to change { @decision.aac_import_errors.count }.by 1
    end
  end
end
