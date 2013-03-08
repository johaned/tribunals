class DecisionsController < ApplicationController
  def index
    if params[:search].present?
      @decisions = Decision.ordered.advanced_search(:text => params[:search]).paginate(:page => params[:page], :per_page => 30)
    else
      @decisions = Decision.ordered.paginate(:page => params[:page], :per_page => 30).all
    end
  end

  def show
    @decision = Decision.find(params[:id])
  end
end
