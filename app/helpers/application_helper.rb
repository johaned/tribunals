module ApplicationHelper
	def hilighted_search_result(search_term, text)
		excerpt = excerpt(text, search_term, :radius => 50)
		highlight(excerpt, search_term, :highlighter => '<span class=\'result\'>\1</span>')
	end
end
