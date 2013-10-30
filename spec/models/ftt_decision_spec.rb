require 'spec_helper'

describe FttDecision do
  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @ftt_decision = FttDecision.create!(ftt_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @ftt_decision.doc_file.file.instance_variable_set(:@file, nil)
        @ftt_decision.process_doc
      end

      after(:all) do
        @ftt_decision.destroy
        File.unlink(File.join(Rails.root, 'tmp', 'test.html'))
        File.unlink(File.join(Rails.root, 'tmp', 'test.pdf'))
      end

      it "should save a tmp html file" do
        @ftt_decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @ftt_decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @ftt_decision.text.should == "Test\n"
      end
    end
  end
end
