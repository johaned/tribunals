class Admin::DecisionsController < ApplicationController
  def index
    @decisions = Decision.all.paginate(:page => params[:page])
  end

  def create
    @decision = Decision.new(params[:decision])
    if @decision.save
      redirect_to :action => :index
    end
  end

  def new
    @decision = Decision.new(params[:decision])
  end
end
