require 'spec_helper'

describe Admin::DecisionsController do
  before(:each) do
    Decision.create!(promulgated_on: Date.today)
    Decision.create!(promulgated_on: Date.new(2012, 12, 31))
  end

  it "uses a scope that makes all decisions accessible" do
    subject.class.scope.count == 2
  end

  describe "GET 'index'" do
    it "uses the controller scope" do
      subject.class.should_receive(:scope).and_call_original
      get :index
    end
  end
end
