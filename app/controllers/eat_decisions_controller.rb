class EatDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(EatDecision.maximum(:updated_at))
    
    params[:search] ||= {}
    @eat_decisions = EatDecision.all.ordered.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @eat_decision = EatDecision.find(params[:id])
    set_cache_control(@eat_decision.updated_at)
  end
end
