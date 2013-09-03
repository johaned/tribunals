require 'spec_helper'

describe Tribunals::Application.config do
  it "sets cookie only on the /admin path" do
    subject.session_store.should == ActionDispatch::Session::CookieStore
    subject.session_options.should == {cookie_only: true, key: 'TSID', path: '/admin', httponly: true}
  end
end
