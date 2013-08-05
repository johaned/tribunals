require 'spec_helper'

describe AitReportedScraper do
  let(:subject) do
    AitReportedScraper.new(File.open(File::NULL, 'w'))
  end

  context "a page is crawlable" do
    it "should always crawl the first page" do
      subject.should_receive(:decision_exists?).exactly(20).times
      subject.visit_all_pages([])
    end

    it "should crawl additional pages" do
      subject.should_receive(:decision_exists?).exactly(40).times
      subject.visit_all_pages(2..2)
    end
  end

  context "a page is not crawlable" do
    it "should always crawl the first page" do
      subject.should_receive(:decision_exists?).exactly(20).times
      subject.visit_all_pages([])
    end

    it "should not crawl any additional pages if they're not found" do
      subject.should_receive(:decision_exists?).exactly(20).times
      subject.visit_all_pages(20..100)
    end
  end

  it "should set the required attributes on a decision" do
    subject.visit_all_pages([])
    Decision.all.each do |d|
      d.tribunal_id.should == 1
      d.reported.should be_true
      d.case_name.should be_a(String)
      d.promulgated_on.should be_a(Date)
      d.starred.should_not be_nil
      d.country_guideline.should_not be_nil
      d.judges.size.should >= 1
      d.categories.size.should >= 0
      d.appeal_number.should_not be_empty
      d.country.should_not be_empty
      d.claimant.should_not be_empty
      d.keywords.should_not be_empty
      d.case_notes.should be_a(String)
      URI.parse(d.url).should be_a(URI)
    end.should_not be_empty
  end
end
