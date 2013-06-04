require 'spec_helper'

describe DecisionsController do

  describe "GET 'index'" do
  end

  describe "GET 'show'" do
    context "a decision exists as html, doc and pdf" do
      let(:decision) do
        Decision.create(pdf_file: sample_pdf_file, doc_file: sample_doc_file)
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end

      it "should respond with a pdf representation" do
        get :show, id: decision.id, format: 'pdf'
        response.should be_success
        response.content_type.should == 'application/pdf'
      end

      it "should respond with a doc representation" do
        get :show, id: decision.id, format: 'doc'
        response.should be_success
        response.content_type.should == 'application/msword'
      end
    end

    context "only decision metadata exists" do
      let(:decision) do
        Decision.create
      end

      it "should respond with a html representation" do
        get :show, id: decision.id
        response.should be_success
        response.content_type.should == 'text/html'
      end

      it "should respond with 404 not found when requesting representations that do not exist" do
        get :show, id: decision.id, format: :doc
        response.should be_not_found

        get :show, id: decision.id, format: :pdf
        response.should be_not_found
      end
    end
  end
end
