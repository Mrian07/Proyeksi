

class Widget::CostTypes < Widget::Base
  def render_with_options(options, &block)
    @cost_types = options.delete(:cost_types)
    @selected_type_id = options.delete(:selected_type_id)

    super(options, &block)
  end

  def render
    write contents
  end

  def contents
    content_tag :div do
      available_cost_type_tabs(@subject).sort_by { |id, _| id }.map do |id, label|
        content_tag :div, class: "form--field -trailing-label" do
          types = label_tag "unit_#{id}", h(label), class: "form--label"
          types += content_tag :span, class: "form--field-container" do
            content_tag :span, class: "form--radio-button-container" do
              radio_button_tag('unit', id, id == @selected_type_id, class: "form--radio-button")
            end
          end
        end
      end.join('').html_safe
    end
  end
end
