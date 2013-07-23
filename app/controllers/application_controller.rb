class ApplicationController < ActionController::Base
  protect_from_forgery

  force_ssl if: :ssl_configured?

  def ssl_configured?
    headers['X-Forwarded-Proto'] == 'https'
  end
end
