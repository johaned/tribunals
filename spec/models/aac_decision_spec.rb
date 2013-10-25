require 'spec_helper'

describe AacDecision do

  describe "search" do
    before(:each) do
      @aac_decision1 = AacDecision.create!(aac_decision_hash(text: "Some searchable text is here"))
      @aac_decision2 = AacDecision.create!(aac_decision_hash(text: "Some other searchable text is here gerald"))
      @aac_decision3 = AacDecision.create!(aac_decision_hash(text: "gerald"))
      @aac_decision4 = AacDecision.create!(aac_decision_hash(claimant: 'Green'))
      @aac_decision5 = AacDecision.create!(aac_decision_hash(ncn: '[2013] UKUT 456'))
    end

    it "should filter on search text" do
      AacDecision.filtered(:query => "gerald").should == [@aac_decision2, @aac_decision3]
    end
  end

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @aac_decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @aac_decision.doc_file.file.instance_variable_set(:@file, nil)
        @aac_decision.process_doc
      end

      after(:all) do
        @aac_decision.destroy
        File.unlink(File.join(Rails.root, 'tmp', 'test.html'))
        File.unlink(File.join(Rails.root, 'tmp', 'test.pdf'))
      end

      it "should save a tmp html file" do
        @aac_decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @aac_decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @aac_decision.text.should == "Test\n"
      end
    end

    it "should still save if the doc processing fails" do
      @aac_decision = AacDecision.create!(aac_decision_hash(doc_file: File.open(__FILE__)))
      File.should_receive(:open).and_raise(StandardError)
      expect {
        @aac_decision.process_doc
      }.to change { @aac_decision.aac_import_errors.count }.by 1
    end
  end
end
