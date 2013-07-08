module DecisionsHelper
  def reported_label(boolean)
    boolean ? 'Yes' : 'No'
  end

  def search_present()
  	params[:search][:query].present? ? true : false
  end

  def time_element(date)
    ("<time timedate='#{date.to_formatted_s(:rfc3339)}'>#{date.to_formatted_s(:rfc822)}</time>").html_safe
  end

  def schema_time_element(date)
    ("<time property='datePublished' timedate='#{date.to_formatted_s(:rfc3339)}'>#{date.to_formatted_s(:rfc822)}</time>").html_safe
  end

end
