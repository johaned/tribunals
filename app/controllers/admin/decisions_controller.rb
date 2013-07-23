class Admin::DecisionsController < ApplicationController
  layout 'layouts/admin'
  before_filter :authenticate

  def index
    @decisions = self.class.scope.paginate(:page => params[:page])
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
    @decision = self.class.scope.find(params[:id])
  end

  def update
    @decision = self.class.scope.find(params[:id])
    if @decision.update_attributes(params[:decision].permit!)
      redirect_to admin_decisions_path
    else
      redirect_to edit_admin_decision_path(@decision)
    end
  end

  def self.scope
    Decision.all
  end

  private
  def authenticate
    request.env['warden'].authenticate!
  end
end
