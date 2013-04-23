require "spec_helper"

describe ApplicationHelper do
  describe "#hilighted_search_result" do
    it "excerpts and hilights the result from the text" do
      text = "This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term This the the article that contains the search term"
      helper.hilighted_search_result("contains", text).should ==
      	"This the the article that <span class='result'>contains</span> the search term This the the article that contain..."
    end
  end
end
