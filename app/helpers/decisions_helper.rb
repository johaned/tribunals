module DecisionsHelper
  def reported_label(boolean)
    boolean ? 'Yes' : 'No'
  end

  def search_present()
  	params[:search][:query].present? ? true : false
  end
end
