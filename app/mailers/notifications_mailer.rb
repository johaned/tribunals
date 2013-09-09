class NotificationsMailer < ActionMailer::Base

  default to: ENV['FEEDBACK_EMAIL_RECEIVER'], from: "no-reply@tribunalsdecisions.service.gov.uk"

  def new_message(message)
    @message = message
    mail(:subject => "New feedback for UTIAC Tribunals Decisions")
  end
end
