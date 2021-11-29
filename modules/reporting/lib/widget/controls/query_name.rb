

class Widget::Controls::QueryName < Widget::Controls
  dont_cache! # The name might change, but the query stays the same...

  def render
    options = { id: 'query_saved_name', 'data-translations' => translations }
    if @subject.new_record?
      name = I18n.t(:label_new_report)
      icon = ''
    else
      name = @subject.name
      options['data-is_public'] = @subject.public?
      options['data-is_new'] = @subject.new_record?
    end
    write(content_tag(:span, h(name), options) + icon.to_s)
  end

  def translations
    { isPublic: I18n.t(:field_is_public) }.to_json
  end
end
