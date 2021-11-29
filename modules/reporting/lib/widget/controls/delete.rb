

class Widget::Controls::Delete < Widget::Controls
  def render
    return '' if @subject.new_record? or !@options[:can_delete]

    button = link_to(I18n.t(:button_delete),
                     '#',
                     id: 'query-icon-delete',
                     class: 'button icon-context icon-delete')
    popup = content_tag :div, id: 'delete_form', style: 'display:none', class: 'button_form' do
      question = content_tag :p, I18n.t(:label_really_delete_question)

      url_opts = { id: @subject.id }
      url_opts[request_forgery_protection_token] = form_authenticity_token # if protect_against_forgery?
      opt1 = link_to I18n.t(:button_delete),
                     url_for(url_opts),
                     method: :delete,
                     class: 'button -highlight icon-context icon-delete'
      opt2 = link_to I18n.t(:button_cancel),
                     '#',
                     id: 'query-icon-delete-cancel',
                     class: 'button icon-context icon-cancel'
      opt1 + opt2

      question + opt1 + opt2
    end
    write(button + popup)
  end
end
