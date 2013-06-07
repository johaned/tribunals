require 'spec_helper'

describe DecisionsController do

  describe "GET 'index'" do
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
