class DecisionsController < ApplicationController
  before_filter :enable_varnish

  def index
    set_cache_control(Decision.maximum(:updated_at))
    
    params[:search] ||= {}
    params[:search][:reported]
    params[:search][:country_guideline] = nil if params[:search][:country_guideline] == '0'
    @decisions = self.class.scope.ordered.paginate(:page => params[:page], :per_page => 30)
    @decisions = @decisions.filtered(params[:search]) if params[:search].present?
  end

  def show
    @decision = self.class.scope.find(params[:id])
    set_cache_control(@decision.updated_at)
  end

  def self.scope
    Decision.viewable
  end
end
