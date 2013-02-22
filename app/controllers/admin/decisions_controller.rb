class Admin::DecisionsController < ApplicationController
  def index
    @decisions = Decision.all
  end

  def create
    @decision = Decision.new(params[:decision])
    if @decision.save
      redirect_to :action => :index
    end
  end
end
