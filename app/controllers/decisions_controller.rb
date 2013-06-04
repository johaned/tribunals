class DecisionsController < ApplicationController
  def index
    params[:search] ||= {}
    params[:search][:reported]
    params[:search][:country_guideline] = nil if params[:search][:country_guideline] == '0'
    @decisions = Decision.paginate(:page => params[:page], :per_page => 30).ordered
    if params[:search].present?
      @decisions = @decisions.filtered(params[:search])
    end
  end

  def show
    @decision = Decision.find(params[:id])
    @page_title = @decision.label

    respond_to do |format|
      format.html
      format.doc { @decision.doc_file.present? ? send_file(@decision.doc_file.path, disposition: 'attachment') : head(:not_found) }
      format.pdf { @decision.pdf_file.present? ? send_file(@decision.pdf_file.path, disposition: 'attachment') : head(:not_found) }
    end
  end
end
