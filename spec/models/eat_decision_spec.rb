require 'spec_helper'

describe EatDecision do

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @eat_decision = EatDecision.create!(eat_decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
        # Workaround for a bug in carrierwave, when Fog.mock! is used.
        @eat_decision.doc_file.file.instance_variable_set(:@file, nil)
        @eat_decision.process_doc
      end

      after(:all) do
        @eat_decision.destroy
        delete_test_files
      end

      it "should save a tmp html file" do
        @eat_decision.html.should include('Test<br/>')
      end

      it "should save the pdf file" do
        @eat_decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @eat_decision.text.should == "Test\n"
      end
    end
  end
end
