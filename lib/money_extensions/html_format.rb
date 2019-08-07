# frozen_string_literal: true

require 'active_support/core_ext/string/output_safety'

module HtmlFormat
  def format(**rules)
    html_wrap = rules.delete(:html_wrap)
    return html_wrap(super(**rules)) if html_wrap

    super(**rules)
  end

  def as_html(**rules)
    rules[:html_wrap] = true
    format(**rules).html_safe
  end

  private

  def html_wrap(str)
    "<span class=\"money #{direction_class}\">#{str}</span>"
  end

  def direction_class
    if cents > 0
      'positive'
    elsif cents < 0
      'negative'
    else
      'zero'
    end
  end
end

class Money
  prepend HtmlFormat
end
