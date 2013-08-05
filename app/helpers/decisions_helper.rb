module DecisionsHelper
  def reported_label(boolean)
    boolean ? 'Yes' : 'No'
  end

  def search_present
    params[:search][:query].present?
  end

  def time_element(date)
    ("<time timedate='#{date.to_formatted_s(:rfc3339)}'>#{date.to_formatted_s(:rfc822)}</time>").html_safe
  end

  def schema_time_element(date)
    ("<time property='datePublished' timedate='#{date.to_formatted_s(:rfc3339)}'>#{date.to_formatted_s(:rfc822)}</time>").html_safe
  end

  def judge_list(judges)
    judges.map { |judge| schema_author_span(judge) }.join(', ').html_safe
  end

  def schema_author_span(author)
    ("<span property='author'>#{author}</span>").html_safe
  end

  def case_title(decision)
    decision.case_name || decision.claimant + ' (' + decision.keywords.join(', ').html_safe + ')'
  end

end
