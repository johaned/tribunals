require 'spec_helper'

describe Decision do
  describe "with a .doc" do
    before(:each) do
      @decision = Decision.new(:doc_file => File.open(File.join(Rails.root, 'spec', 'data', 'test.doc')))
      @decision.stub!(:process_doc)
    end

    it "should save" do
      @decision.save.should be_true
    end

    it "should call process_doc" do
      @decision.should_receive(:process_doc)
      @decision.save
    end

    describe "process_doc" do
      it "should save a tmp html file" do
        @decision.unstub(:process_doc)
        @decision.save
        @decision.html.should include('Test</p>')
      end
    end

  end

end