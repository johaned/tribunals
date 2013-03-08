class DecisionsController < ApplicationController
  def index
    if params[:search].present?
      @decisions = Decision.advanced_search(:text => params[:search]).paginate(:page => params[:page], :per_page => 30)
    else
      @decisions = Decision.paginate(:page => params[:page], :per_page => 30).all
    end
  end

  def show
    @decision = Decision.find(params[:id])
  end
end
