require 'spec_helper'

describe DecisionsHelper do
  it "displays time via time_element" do
    date = Date.new(2013, 10, 1)

    helper.time_element(date).should == "<time timedate='2013-10-01'> 1 Oct 2013</time>"
    helper.time_element(nil).should be_nil
  end

  it "displays time via schema_time_element" do
    date = Date.new(2013, 10, 1)

    helper.schema_time_element(date).should == "<time property='datePublished' timedate='2013-10-01'> 1 Oct 2013</time>"
    helper.schema_time_element(nil).should be_nil
  end
end
