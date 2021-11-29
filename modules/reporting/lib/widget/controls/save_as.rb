

class Widget::Controls::SaveAs < Widget::Controls
  def render
    if @subject.new_record?
      link_name = I18n.t(:button_save)
      icon = 'icon-save'
    else
      link_name = I18n.t(:button_save_as)
      icon = 'icon-save'
    end
    button = link_to(link_name, '#', id: 'query-icon-save-as', class: "button icon-context #{icon}")
    write(button + render_popup)
  end

  def cache_key
    "#{super}#{@subject.name}"
  end

  def render_popup_form
    name = content_tag :p,
                       class: 'form--field -required -wide-label' do
      label_tag(:query_name,
                class: 'form--label -transparent') do
        Query.human_attribute_name(:name).html_safe
      end +
        content_tag(:span,
                    class: 'form--field-container') do
          content_tag(:span,
                      class: 'form--text-field-container') do
            text_field_tag(:query_name,
                           @subject.name,
                           required: true)
          end
        end
    end
    if @options[:can_save_as_public]
      box = content_tag :p, class: 'form--field -wide-label' do
        label_tag(:query_is_public,
                  Query.human_attribute_name(:is_public),
                  class: 'form--label -transparent') +
          content_tag(:span,
                      class: 'form--field-container') do
            content_tag(:span,
                        class: 'form--check-box-container') do
              check_box_tag(:query_is_public,
                            1,
                            false,
                            class: 'form--check-box')
            end
          end
      end
      name + box
    else
      name
    end
  end

  def render_popup_buttons
    save_url_params = { action: 'create', set_filter: '1' }
    save_url_params[:project_id] = @subject.project.id if @subject.project

    save = link_to(I18n.t(:button_save),
                   '#',
                   id: 'query-icon-save-button',
                   class: 'button -highlight icon-context icon-save',
                   "data-target": url_for(**save_url_params))

    cancel = link_to(I18n.t(:button_cancel),
                     '#',
                     id: 'query-icon-save-as-cancel',
                     class: 'button icon-context icon-cancel')
    save + cancel
  end

  def render_popup
    content_tag :div, id: 'save_as_form', class: 'button_form', style: 'display:none' do
      render_popup_form + render_popup_buttons
    end
  end
end
