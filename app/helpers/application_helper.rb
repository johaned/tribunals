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
end
