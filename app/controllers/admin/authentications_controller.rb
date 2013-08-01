class Admin::AuthenticationsController < ApplicationController
  layout 'layouts/admin'

  def new
  end

  def create
    warden.authenticate!
    redirect_to admin_decisions_path
  end

  def logout
    warden.logout
    redirect_to root_url
  end
end
