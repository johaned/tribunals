module ApplicationHelper
  def hilighted_search_result(search_term, text)
    search_regexp = /\b#{Regexp.escape(search_term)}\b/i
    if excerpt = excerpt(text, search_regexp, radius: 10, separator: ' ')
      highlight(excerpt, search_regexp, :highlighter => '<span class=\'result\'>\1</span>')
    end
  end

  def page_title(prefix=nil)
    if prefix
      [prefix, 'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'].join(' | ')
    else
      'Upper Tribunal (Immigration and Asylum Chamber) Decision Database'
    end
  end

  # Backports from bleeding edge rails.
  def excerpt(text, phrase, options = {})
    return unless text && phrase

    separator = options.fetch(:separator, "")
    if Regexp === phrase
      regex = phrase
    else
      phrase    = Regexp.escape(phrase)
      regex     = /#{phrase}/i
    end

    return unless matches = text.match(regex)
    phrase = matches[0]

    unless separator.empty?
      text.split(separator).each do |value|
        if value.match(regex)
          regex = phrase = value
          break
        end
      end
    end

    first_part, second_part = text.split(regex, 2)

    prefix, first_part   = cut_excerpt_part(:first, first_part, separator, options)
    postfix, second_part = cut_excerpt_part(:second, second_part, separator, options)

    prefix + (first_part + separator + phrase + separator + second_part).strip + postfix
  end

  def highlight(text, phrases, options = {})
    text = sanitize(text) if options.fetch(:sanitize, true)

    if text.blank? || phrases.blank?
      text
    else
      highlighter = options.fetch(:highlighter, '<mark>\1</mark>')
      match = Array(phrases).map do |p|
        Regexp === p ? p.to_s : Regexp.escape(p)
      end.join('|')
      text.gsub(re = /(#{match})(?![^<]*?>)/i, highlighter)
    end.html_safe
  end

  def time_element(date)
    if date
      ("<time timedate='#{date.to_formatted_s(:rfc3339)}'>#{date.to_formatted_s(:rfc822)}</time>").html_safe
    end
  end
end
