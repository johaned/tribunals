class AacDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(AacDecision.maximum(:updated_at))
    
    params[:search] ||= {}
    @aac_decisions = AacDecision.all.ordered.paginate(:page => params[:page], :per_page => 30)
    @aac_decisions = @aac_decisions.filtered(params[:search]) if params[:search].present?    
  end

  def show
    @aac_decision = AacDecision.find(params[:id])
    set_cache_control(@aac_decision.updated_at)
  end
end
