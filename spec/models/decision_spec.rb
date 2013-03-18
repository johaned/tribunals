require 'spec_helper'

describe Decision do
  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @decision = Decision.create!(:doc_file => File.open(File.join(Rails.root, 'spec', 'data', 'test.doc')))
        @decision.process_doc
      end

      after(:all) do
        @decision.destroy
        File.unlink(File.join(Rails.root, 'tmp', 'test.html'))
        File.unlink(File.join(Rails.root, 'tmp', 'test.pdf'))
      end

      it "should save a tmp html file" do
        @decision.html.should include('Test</p>')
      end

      it "should save the pdf file" do
        @decision.pdf_file.should be_a(PdfFileUploader)
      end

      it "should save the raw text of the document" do
        @decision.text.should == "Test"
      end
    end

    it "should still save if the doc processing fails" do
      @decision = Decision.create!(:doc_file => File.open(__FILE__))
      @decision.process_doc
      @decision.import_errors.count.should == 1
      @decision.import_errors.first.error.should include("No such file or directory")
    end
  end

  describe "html_body" do
    it "should extract all the contents of the html body" do
      @decision = Decision.new(:html => "<html><head></head><body>Contents <p><span>other</span></p></body>")
      @decision.html_body.should == "Contents <p><span>other</span></p>"
    end  
  end

  describe "extract_appeal_number" do
    it "should extract the appeal number in format Appeal Numbers: IA/37982/2010" do
      @decision = Decision.new(:text => "Appeal Numbers: IA/37982/2010")
      @decision.extract_appeal_number
      @decision.appeal_number.should == "IA/37982/2010"
    end
    it "should extract the appeal number in format Appeal Number: IA/37982/2010" do
      @decision = Decision.new(:text => "Appeal Number: IA/37982/2010")
      @decision.extract_appeal_number
      @decision.appeal_number.should == "IA/37982/2010"
    end
    it "should extract the appeal number in format Appeal Number: IA 37982 2010" do
      @decision = Decision.new(:text => "Appeal Number: IA 37982 2010")
      @decision.extract_appeal_number
      @decision.appeal_number.should == "IA/37982/2010"
    end
  end
end