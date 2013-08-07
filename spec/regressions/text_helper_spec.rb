require 'spec_helper'

describe ActionView::Helpers::TextHelper do
  let(:helper) do
    Class.new do
      include ActionView::Helpers::TextHelper
    end.new
  end

  it "excerpt doesn't accept regular expressions yet" do
    expect {
      helper.excerpt("This was a challenging day for judge Allen and his colleagues", /\ballen\b/i)
    }.to raise_error(TypeError)
  end

  it "highlight doesn't accept regular expressions yet" do
    expect {
      helper.highlight("This was a challenging day for judge Allen and his colleagues", /\ballen\b/i)
    }.to raise_error(TypeError)
  end
end
