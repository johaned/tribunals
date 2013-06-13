require 'spec_helper'

describe DecisionsController do

  describe "controller scope" do
    before(:each) do
      Decision.create!(promulgated_on: Date.today)
      Decision.create!(promulgated_on: Date.new(2012, 12, 31))
    end

    it "uses a cope that makes decisions promulgated on or after Jan 1, 2013 accessible" do
      subject.class.scope.count == 1
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
        Decision.create!(pdf_file: sample_pdf_file, doc_file: sample_doc_file, promulgated_on: Date.today)
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
        Decision.create!(promulgated_on: Date.today)
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end
    end
  end
end
