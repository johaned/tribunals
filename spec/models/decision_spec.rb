require 'spec_helper'

describe Decision do

  describe "search" do
    before(:each) do
      @decision1 = Decision.create!(decision_hash(text: "Some searchable text is here"))
      @decision2 = Decision.create!(decision_hash(text: "Some other searchable text is here gerald", country: 'Afghanitsan'))
      @decision3 = Decision.create!(decision_hash(text: "gerald", country_guideline: true, country: 'Iraq', judges: ["Blake", "Smith"]))
      @decision4 = Decision.create!(decision_hash(claimant: 'Green'))
      @decision5 = Decision.create!(decision_hash(ncn: '[2013] UKUT 456'))
      @decision6 = Decision.create!(decision_hash(appeal_number: 'AA/11055/2012', reported: false))
    end

    it "should filter on search text" do
      Decision.filtered(:query => "gerald").should == [@decision2, @decision3]
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

    it "should filter a search and display exact matches first" do
      Decision.filtered(:query => 'some searchable').should == [@decision1, @decision2]
    end

    it "should treat an NCN-like search term as search by NCN number" do
      Decision.filtered(query: '[2013] UKUT 456').should == [@decision5]
    end

    it "should treat an appeal-number-like search term as search by appeal number" do
      Decision.filtered(query: 'AA/11055/2012').should == [@decision6]
    end
  end

  describe "with a .doc" do
    describe "process_doc" do
      before(:all) do
        @decision = Decision.create!(decision_hash(doc_file: File.open(File.join(Rails.root, 'spec', 'data', 'test.doc'))))
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
      @decision = Decision.create!(decision_hash(doc_file: File.open(__FILE__)))
      File.should_receive(:open).and_raise(StandardError)
      expect {
        @decision.process_doc
      }.to change { @decision.import_errors.count }.by 1
    end
  end

  describe "judge_list" do
    before(:each) do
      Decision.create!(decision_hash(judges: ["Gregg"]))
      Decision.create!(decision_hash(judges: ["Blake"]))
      Decision.create!(decision_hash(judges: ["Blake", "Smith"]))
    end

    it "lists unique list of all judged in ascending order" do
      Decision.judges_list.should == ["Blake", "Gregg", "Smith"]
    end
  end

  describe "country_list" do
    before :each do
      Decision.create!(decision_hash(country: 'Poland'))
      Decision.create!(decision_hash(country: 'Vanuatu'))
      Decision.create!(decision_hash(country: 'Kiribati'))
      Decision.create!(decision_hash(country: 'Kiribati'))
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
      @target_decision = Decision.create!(decision_hash(:appeal_number => '[1238] UKUT 12'))
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

  describe "link label" do
    context "a reported decision" do
      it "should display the appropriate label" do
        decision = Decision.create!(decision_hash(ncn: 'XYZ 123'))
        decision.link_label.should == 'XYZ 123'
      end
    end

    context "an old unreported decision" do
      it "should display the appropriate label" do
        decision = Decision.new(decision_hash(reported: false, doc_file: sample_doc_file2))
        decision.try_extracting_appeal_numbers
        decision.save(validate: false)
        decision.link_label.should == 'IA/19540/2012, IA/19541/2012, AA/09916/2012'
      end
    end

    context "an unreported decision" do
      it "should display the appropriate label" do
        decision = Decision.create!(decision_hash(reported: false, doc_file: sample_doc_file2, appeal_number: 'LOL 31337'))
        decision.link_label.should == 'LOL 31337'
      end
    end
  end

  describe "viewable scope" do
    before(:each) do
      Decision.create!(decision_hash(reported: false, appeal_number: 'LOL 31337'))
      Decision.create!(decision_hash(promulgated_on: Date.new(2012, 12, 31), reported: false, appeal_number: 'LOL 31338'))
      Decision.create!(decision_hash(promulgated_on: Date.new(2001, 1, 1)))
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

  describe "validation" do
    context "reported case" do
      it "validates" do
        decision = Decision.new(reported: true)

        decision.ncn = 'XYZ 123'
        decision.should_not be_valid

        decision.country = 'Mali'
        decision.should_not be_valid

        decision.country_guideline = false
        decision.should_not be_valid

        decision.claimant = 'John Smith'
        decision.should_not be_valid

        decision.promulgated_on = Date.today
        decision.should_not be_valid

        decision.judges = ['His Hon Judge Dredd']
        decision.should_not be_valid

        decision.doc_file = sample_doc_file
        decision.should be_valid
      end
    end

    context "unreported case" do
      it "validates" do
        decision = Decision.new(reported: false)

        decision.appeal_number = 'XYZ 123'
        decision.should_not be_valid

        decision.doc_file = sample_doc_file
        decision.should be_valid
      end
    end
  end
end
