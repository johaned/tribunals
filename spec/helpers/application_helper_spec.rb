require "spec_helper"

describe ApplicationHelper do
  describe "#hilighted_search_result" do
    let(:text) do
      "This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term"
    end

    it "excerpts and hilights the result from the text" do
      helper.hilighted_search_result("contains", text).should ==
      	"This the the article that <span class='result'>contains</span> the search term This the the article that contain..."
    end

    it "doesn't blow up when the text to be highlighted doesn't appear in the decision" do
      helper.hilighted_search_result("blah blah blah", text).should be_nil
    end
  end
end
