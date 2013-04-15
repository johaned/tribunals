require 'spec_helper'

describe Decision do

  describe "search" do
    before(:each) do
      @decision1 = Decision.create!(:text => "Some searchable text is here")
      @decision2 = Decision.create!(:text => "Some other searchable text is here gerald", :country => 'Afghanitsan')
      @decision3 = Decision.create!(:text => "gerald", :reported => true, :country_guideline => true, :country => 'Iraq', :judges => ["Blake", "Smith"])
    end
    it "should filter on search text" do
      Decision.filtered(:query => "gerald").should == [@decision2, @decision3]
    end
    it "should filter on search text and reported" do
      Decision.filtered(:query => "gerald", :reported => true).should == [@decision3]
    end
    it "should filter on search text and country guidline" do
      Decision.filtered(:query => "gerald", :country_guideline => true).should == [@decision3]
    end
    it "should filter on search text and country" do
      Decision.filtered(:query => "gerald", :country => 'Iraq').should == [@decision3]
    end
    it "should filter on search text and judge" do
      Decision.filtered(:query => "gerald", :judge => 'Blake').should == [@decision3]
    end
  end
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

  describe "judge_list" do
    before(:each) do
      @decision1 = Decision.create!(:judges => ["gregg"])
      @decision2 = Decision.create!(:judges => ["Blake"])
      @decision3 = Decision.create!(:judges => ["Blake", "Smith"])
    end
    it "should list unique list of all judged" do
      Decision.judges_list.should == ["Blake", "gregg", "Smith"]
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