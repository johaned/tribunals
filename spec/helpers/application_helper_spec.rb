require "spec_helper"

describe ApplicationHelper do
  describe "#hilighted_search_result" do
    let(:text) do
      "This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term"
    end

    it "excerpts and hilights the result from the text" do
      helper.hilighted_search_result("contains", text).should ==
        "This the the article that <span class='result'>contains</span> the search term This the the article that <span class='result'>contains</span> the..."
    end

    it "doesn't blow up when the text to be highlighted doesn't appear in the decision" do
      helper.hilighted_search_result("blah blah blah", text).should be_nil
    end
  end

  describe "page_title" do
    it "displays the page title with an optional prefix" do
      helper.page_title.should == 'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
      @decision = Decision.new(decision_hash(ncn: '[2013] UKUT 356', claimant: 'Mr Green', keywords: ['green', 'tomatoes']))
      helper.page_title.should == '[2013] UKUT 356 - Mr Green (green, tomatoes) | Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
      @decision = Decision.new(decision_hash(reported: false, appeal_number: 'VA/16664/2012'))
      helper.page_title.should == 'VA/16664/2012 | Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
    end
  end
end
