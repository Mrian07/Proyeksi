

class Widget::Controls::Clear < Widget::Controls
  def render
    write link_to(I18n.t(:button_clear),
                  '#',
                  id: 'query-link-clear',
                  class: 'button icon-context icon-undo')
  end
end
