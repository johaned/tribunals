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
      sign_in
      subject.class.should_receive(:scope).and_call_original
      get :index
    end
  end

  describe "POST 'update'" do
    let(:decision) do
      Decision.create!(promulgated_on: Date.today)
    end

    it "updates a decision" do
      sign_in
      expect {
        post :update, id: decision.id, decision: { appeal_number: 1234 }
        response.should redirect_to(admin_decisions_path)
      }.to change { decision.reload.appeal_number }
    end
  end
end
