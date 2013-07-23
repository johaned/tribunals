require 'spec_helper'

describe Decision do

  describe "search" do
    before(:each) do
      @decision1 = Decision.create!(:text => "Some searchable text is here", :promulgated_on => Date.today)
      @decision2 = Decision.create!(:text => "Some other searchable text is here gerald", :country => 'Afghanitsan', :promulgated_on => Date.today)
      @decision3 = Decision.create!(:text => "gerald", :reported => true, :country_guideline => true, :country => 'Iraq', :judges => ["Blake", "Smith"], :promulgated_on => Date.today)
      @decision4 = Decision.create!(:claimant => 'Green')
      @decision5 = Decision.create!(:appeal_number => '[2013] UKUT 456')
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

    it "should filter a search on claimant (case-insensitive)" do
      Decision.by_claimant('green').should == [@decision4]
      Decision.by_claimant('Green').should == [@decision4]
    end

    it "should filter a search on NCN (case-insensitive)" do
      Decision.by_ncn("ukut 456").should == [@decision5]
      Decision.by_ncn("UKUT 456").should == [@decision5]
      Decision.by_ncn("456").should == [@decision5]
    end
  end

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @decision = Decision.create!(:doc_file => File.open(File.join(Rails.root, 'spec', 'data', 'test.doc')), :promulgated_on => Date.today)
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
      @decision = Decision.create!(:doc_file => File.open(__FILE__), :promulgated_on => Date.today)
      File.should_receive(:open).and_raise(StandardError)
      expect {
        @decision.process_doc
      }.to change { @decision.import_errors.count }.by 1
    end
  end

  describe "judge_list" do
    before(:each) do
      Decision.create!(:judges => ["Gregg"], :promulgated_on => Date.today)
      Decision.create!(:judges => ["Blake"], :promulgated_on => Date.today)
      Decision.create!(:judges => ["Blake", "Smith"], :promulgated_on => Date.today)
    end

    it "lists unique list of all judged in ascending order" do
      Decision.judges_list.should == ["Blake", "Gregg", "Smith"]
    end
  end

  describe "country_list" do
    before :each do
      Decision.create!(:country => 'Poland', :promulgated_on => Date.today)
      Decision.create!(:country => 'Vanuatu', :promulgated_on => Date.today)
      Decision.create!(:country => 'Kiribati', :promulgated_on => Date.today)
      Decision.create!(:country => 'Kiribati', :promulgated_on => Date.today)
    end

    it "lists a unique set of countries in ascending order" do
      Decision.country_list.should == ['Kiribati', 'Poland', 'Vanuatu']
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


  describe "appeal_references" do
    before(:each) do
      @target_decision = Decision.create!(:appeal_number => '[1238] UKUT 12')
      @target_decision_url = Tribunals::Application.routes.url_helpers.decision_path(@target_decision)
    end

    it "should find appeal references when converting text to html" do
      @source_decision = Decision.new(:text => 'blah blah [1238] UKUT 12 blah')
      @source_decision.set_html_from_text
      @source_decision.html.should == 'blah blah <a href=\'' + @target_decision_url + '\'>[1238] UKUT 12</a> blah'
    end

    it "should find ignore heading 0s in references" do
      @source_decision = Decision.new(:text => 'blah blah [1238] UKUT 0012 blah')
      @source_decision.set_html_from_text
      @source_decision.html.should == 'blah blah <a href=\'' + @target_decision_url + '\'>[1238] UKUT 0012</a> blah'
    end
  end

  describe "label" do
    it "should display the appropriate label" do
      decision = Decision.new(:appeal_number => 'XYZ 123', :case_name => 'Smith vs Brown', :reported => true)
      decision.label.should == 'XYZ 123 - Smith vs Brown'
      
      decision = Decision.new
      decision.label.should be_nil
    end
  end

  describe "viewable scope" do
    before(:each) do
      Decision.create!(promulgated_on: Date.today, reported: false)
      Decision.create!(promulgated_on: Date.new(2012, 12, 31), reported: false)
      Decision.create!(promulgated_on: Date.new(2001, 1, 1), reported: true)
    end

    it "permits access only to a subset of decisions" do
      Decision.viewable.count.should == 2
      Decision.viewable.each do |decision|
        unless decision.reported || decision.promulgated_on >= Date.new(2013, 6, 1)
          fail
        end
      end
    end
  end
end
