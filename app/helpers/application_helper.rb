module ApplicationHelper
  def hilighted_search_result(search_term, text)
    if excerpt = excerpt(text, search_term, radius: 5, separator: ' ')
      highlight(excerpt, search_term, :highlighter => '<span class=\'result\'>\1</span>')
    end
  end

  def page_title(prefix=nil)
    if prefix
      [prefix, 'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'].join(' | ')
    else
      'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
    end
  end
end
