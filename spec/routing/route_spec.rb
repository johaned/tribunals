require 'spec_helper'

describe Tribunals::Application.routes do
  include RSpec::Rails::RequestExampleGroup

  it "redirects from / to /utiac/decisions" do
    get '/'
    response.should redirect_to(decisions_path)
  end

  it "redirects from /utiac to /utiac/decisions" do
    get '/utiac'
    response.should redirect_to(decisions_path)
  end
end

