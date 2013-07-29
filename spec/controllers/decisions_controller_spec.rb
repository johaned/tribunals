require 'spec_helper'

describe DecisionsController do

  describe "controller scope" do
    it "uses a scope that displays only certain decisions" do
      Decision.should_receive(:viewable).once
      subject.class.scope
    end
  end

  describe "GET 'index'" do
    it "uses the controller scope" do
      subject.class.should_receive(:scope).and_call_original
      get :index
    end
  end

  describe "GET 'show'" do
    context "a decision exists as html, doc and pdf" do
      let(:decision) do
        Decision.create!(decision_hash(pdf_file: sample_pdf_file, doc_file: sample_doc_file))
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
        Decision.create!(decision_hash)
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end
    end
  end
end
