

class Widget::Controls::Save < Widget::Controls
  def render
    return '' if @subject.new_record? or !@options[:can_save]

    write link_to(I18n.t(:button_save),
                  '#',
                  id: 'query-breadcrumb-save',
                  class: 'button icon-context icon-save',
                  "data-target": url_for(action: 'update', id: @subject.id, set_filter: '1'))
  end
end
