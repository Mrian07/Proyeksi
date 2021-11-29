

class Widget::Controls::Apply < Widget::Controls
  def render
    write link_to(I18n.t(:button_apply),
                  '#',
                  id: 'query-icon-apply-button',
                  class: 'button -highlight',
                  'data-target': url_for(action: 'index', set_filter: '1'))
  end
end
