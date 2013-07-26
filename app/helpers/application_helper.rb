module ApplicationHelper
  def hilighted_search_result(search_term, text)
    if excerpt = excerpt(text, search_term, :radius => 50)
      highlight(excerpt, search_term, :highlighter => '<span class=\'result\'>\1</span>')
    end
  end

  def page_title
    if @page_title
      [@page_title, 'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'].join(' | ')
    else
      'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
    end
  end

  # Fast, but inexact reimplementation of excerpt() from Rails.
  def excerpt(text, search_term, options={})
    return if search_term.blank? || text.blank?
    radius = options.fetch(:radius, 10)

    if index = text.index(search_term)
      lower_bound = [index - radius, 0].max
      upper_bound = index + search_term.length + radius
      [lower_bound == 0 ? '' : '...', text[lower_bound..upper_bound], upper_bound == text.length ? '' : '...'].join
    end
  end
end
