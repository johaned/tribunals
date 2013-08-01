require 'spec_helper'

describe Admin::DecisionsController do
  render_views

  describe "authorization" do
    it "doesn't let people in by default" do
      get :index
      response.should render_template("admin/authentications/new")
    end
  end

  describe "controller scope" do
    it "uses a scope that makes all decisions accessible" do
      Decision.should_receive(:all).once
      subject.class.scope
    end
  end

  describe "GET 'index'" do
    it "uses the controller scope" do
      sign_in
      subject.class.should_receive(:scope).and_call_original
      get :index
    end
  end

  describe "GET 'show'" do
    before(:each) do
      sign_in
    end

    context "a decision exists as html, doc and pdf" do
      let(:decision) do
        Decision.create!(decision_hash(pdf_file: sample_pdf_file, doc_file: sample_doc_file, promulgated_on: Date.new(2001, 1, 1)))
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end

      it "uses the controller scope" do
        subject.class.should_receive(:scope).and_call_original
        get :show, id: decision.id
      end
    end

    context "only decision metadata exists" do
      let(:decision) do
        Decision.create!(decision_hash(promulgated_on: Date.new(2001, 1, 1)))
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end
    end
  end

  describe "POST 'update'" do
    let(:decision) do
      Decision.create!(decision_hash)
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
