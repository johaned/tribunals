class Admin::DecisionsController < ApplicationController
  def index
    @decisions = Decision.all.paginate(:page => params[:page])
  end

  def create
    @decision = Decision.new(params[:decision].permit!)
    if @decision.save
      @decision.process_doc
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def new
    @decision = Decision.new(params[:decision])
  end
end
