class DecisionsController < ApplicationController
  def index
    omit_if_fresh(self.class.scope.maximum(:updated_at))

    params[:search] ||= {}
    params[:search][:reported]
    params[:search][:country_guideline] = nil if params[:search][:country_guideline] == '0'
    @decisions = self.class.scope.paginate(:page => params[:page], :per_page => 30)
    if params[:search].present?
      @decisions = @decisions.filtered(params[:search])
    else
      @decisions = @decisions.ordered
    end
  end

  def show
    @decision = self.class.scope.find(params[:id])
    omit_if_fresh(@decision.updated_at)
  end

  def self.scope
    Decision.viewable
  end

  def omit_if_fresh(timestamp)
    if Rails.configuration.client_caching
      fresh_when(last_modified: [timestamp, Rails.configuration.version_timestamp].max)
    end
  end
end

