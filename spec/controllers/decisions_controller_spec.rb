require 'spec_helper'

describe DecisionsController do
  render_views

  describe "controller scope" do
    it "uses a scope that displays only certain decisions" do
      Decision.should_receive(:viewable).once
      subject.class.scope
    end

    it "calculates freshness based on the version of the code" do
      decision = Decision.create!(decision_hash)

      with_caching do
        with_version_timestamp(timestamp = Time.now + 1.day) do
          subject.should_receive(:fresh_when).with(last_modified: timestamp)
          get :index
        end
      end
    end

    it "calculates freshness based on the timestamp of the record" do
      decision = Decision.create!(decision_hash).reload

      with_caching do
        with_version_timestamp(Time.at(0)) do
          subject.should_receive(:fresh_when).with(last_modified: decision.updated_at)
          get :index
        end
      end
    end
  end

  describe "GET 'index'" do
    it "uses the controller scope" do
      subject.class.should_receive(:scope).twice.and_call_original
      get :index
    end

    it "should serve a cached version of a page" do
      Decision.create!(decision_hash)
      
      with_caching do
        get :index
        response.should be_success
        request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
        get :index
        response.body.should be_empty
      end
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

      it "should serve a cached version of a page" do
        with_caching do
          get :show, id: decision.id
          response.should be_success
          request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
          get :show, id: decision.id
          response.body.should be_empty
        end
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

      it "should serve a cached version of a page" do
        with_caching do
          get :show, id: decision.id
          response.should be_success
          request.env['HTTP_IF_MODIFIED_SINCE'] = response['Last-Modified']
          get :show, id: decision.id
          response.body.should be_empty
        end
      end
    end
  end
end
