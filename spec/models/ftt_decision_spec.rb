require 'spec_helper'

describe FttDecision do

  describe "search" do
    before(:each) do
      @ftt_decision1 = FttDecision.create!(ftt_decision_hash(text: "Some searchable text is here"))
      @ftt_decision2 = FttDecision.create!(ftt_decision_hash(text: "Some other searchable text is here gerald"))
      @ftt_decision3 = FttDecision.create!(ftt_decision_hash(text: "gerald"))
      @ftt_decision4 = FttDecision.create!(ftt_decision_hash(claimant: 'Green'))
      @ftt_decision5 = FttDecision.create!(ftt_decision_hash(file_number: '[2013] UKUT 456'))
    end

    it "should filter on search text" do
      FttDecision.filtered(:query => "gerald").should == [@ftt_decision2, @ftt_decision3]
    end
  end

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
        delete_test_files
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
