class FttDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(FttDecision.maximum(:updated_at))
    
    params[:search] ||= {}
    @ftt_decisions = FttDecision.all.ordered.paginate(:page => params[:page], :per_page => 30)
    @ftt_decisions = @ftt_decisions.filtered(params[:search]) if params[:search].present?    
  end

  def show
    @ftt_decision = FttDecision.find(params[:id])
    set_cache_control(@ftt_decision.updated_at)
  end
end
