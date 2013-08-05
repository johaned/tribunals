require 'spec_helper'

describe AitUnreportedScraper do
  let(:subject) do
    AitUnreportedScraper.new(File.open(File::NULL, 'w'))
  end

  context "a page is crawlable" do
    it "should always crawl the first page" do
      Decision.should_receive(:exists?).exactly(20).times
      subject.visit_all_pages([])
    end

    it "should crawl additional pages" do
      Decision.should_receive(:exists?).exactly(40).times
      subject.visit_all_pages(2..2)
    end
  end

  context "a page is not crawlable" do
    it "should always crawl the first page" do
      Decision.should_receive(:exists?).exactly(20).times
      subject.visit_all_pages([])
    end

    it "should not crawl any additional pages if they're not found" do
      Decision.should_receive(:exists?).exactly(20).times
      subject.visit_all_pages(20..100)
    end
  end

  it "should set the required attributes on a decision" do
    subject.visit_all_pages([])
    Decision.all.each do |d|
      d.tribunal_id.should == 1
      d.reported.should be_false
      URI.parse(d.url).should be_a(URI)
    end.should_not be_empty
  end
end
