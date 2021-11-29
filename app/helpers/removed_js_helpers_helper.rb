#-- encoding: UTF-8



# Contains tag helpers still existing in the OP code but already
# removed from rails. Please consider removing the occurrences in
# the code rather than adding additional helpers here.

module RemovedJsHelpersHelper
  # removed in rails 4.1
  def link_to_function(content, function, html_options = {})
    id = html_options.delete(:id) { "link-to-function-#{SecureRandom.uuid}" }
    csp_onclick(function, "##{id}")

    content_tag(:a, content, html_options.merge(id: id, href: ''))
  end

  ##
  # Execute the callback on click
  def csp_onclick(callback_str, selector, prevent_default: true)
    content_for(:additional_js_dom_ready) do
      "jQuery('#{selector}').click(function() { #{callback_str}; #{prevent_default ? 'return false;' : ''} });\n".html_safe
    end
  end
end
