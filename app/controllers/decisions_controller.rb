class DecisionsController < ApplicationController
  def index
    omit_if_fresh(last_modified: self.class.scope.maximum(:updated_at))

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
    omit_if_fresh(@decision = self.class.scope.find(params[:id]))
  end

  def self.scope
    Decision.viewable
  end

  private
  def omit_if_fresh(options)
    if Rails.configuration.client_caching
      fresh_when(options)
    end
  end
end

