class DecisionsController < ApplicationController
  def index
    if params[:search].present?
      @decisions = Decision.search(:text => params[:search])
    else
      @decisions = Decision.all
    end
  end

  def show
    @decision = Decision.find(params[:id])
  end
end
