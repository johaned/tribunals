class Admin::AuthenticationsController < ApplicationController
  layout 'layouts/admin'

  def new
  end

  def create
    env['warden'].authenticate!
    redirect_to admin_decisions_path
  end

  def logout
    env['warden'].logout
    redirect_to root_url
  end
end
