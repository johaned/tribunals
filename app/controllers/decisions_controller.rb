class DecisionsController < ApplicationController
  def index
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
    @page_title = @decision.case_name
  end

  def self.scope
    Decision.viewable
  end
end

