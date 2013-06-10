class Admin::DecisionsController < ApplicationController
  layout 'layouts/admin'
  before_filter :authenticate

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

  def edit
    @decision = Decision.find(params[:id])
  end

  private
  def authenticate
    env['warden'].authenticate!
  end
end
