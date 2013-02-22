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
      before(:each) do
        @decision.unstub(:process_doc)
        @decision.save
      end

      after(:each) do
        File.unlink(File.join(Rails.root, 'tmp', 'test.html'))
        File.unlink(File.join(Rails.root, 'tmp', 'test.pdf'))
      end

      it "should save a tmp html file" do
        @decision.html.should include('Test</p>')
      end

      it "should save the pdf file" do
        @decision.pdf_file.should be_a(PdfFileUploader)
      end
    end

  end

end