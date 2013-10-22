class AacDecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(AacDecision.maximum(:updated_at))
    
    params[:search] ||= {}
    @decisions = AacDecision.all.paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @decision = AacDecision.find(params[:id])
    set_cache_control(@decision.updated_at)
  end
end
