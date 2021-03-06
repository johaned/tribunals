require "spec_helper"

describe NotificationsMailer do
  let :form_params do
      {
        :feedback => {
          "rating" => 5,
          "text" => "what a beautiful site",
          "email" => "hermajesty@imperialawesomeness.com"
          },
      "browser" => "Chrome",
      "service" => "Tribunals",
      "referrer" => "some-page-on-the-site"
      }
  end

  before :each do
    NotificationsMailer.default to: "test@dsd.io", from: "no-reply@tribunalsdecisions.service.gov.uk"
    @feedback_email = NotificationsMailer.new_message(form_params)
  end

  it "feedback notification email contains user-submitted feedback rating" do
    @feedback_email.body.raw_source.should include(form_params[:feedback]["rating"].to_s)
  end

  it "feedback notification email contains user-submitted feedback text" do
    @feedback_email.body.raw_source.should include(form_params[:feedback]["text"])
  end

  it "feedback notification email contains user-submitted feedback email" do
    @feedback_email.body.raw_source.should include(form_params[:feedback]["email"])
  end

  it "feedback notification email contains user browser" do
    @feedback_email.body.raw_source.should include(form_params["browser"])
  end

  it "feedback notification email contains service name" do
    @feedback_email.body.raw_source.should include(form_params["service"])
  end

  it "feedback notification email contains referrer" do
    @feedback_email.body.raw_source.should include(form_params["referrer"])
  end
end
