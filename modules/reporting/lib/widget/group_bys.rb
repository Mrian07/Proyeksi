

class Widget::GroupBys < Widget::Base
  def render_options(group_by_ary)
    group_by_ary.sort_by(&:label).map do |group_by|
      next unless group_by.selectable?

      content_tag :option, value: group_by.underscore_name, 'data-label': CGI::escapeHTML(h(group_by.label)).to_s do
        h(group_by.label)
      end
    end.join.html_safe
  end

  def render_group(type, initially_selected)
    initially_selected = initially_selected.map do |group_by|
      [group_by.class.underscore_name, h(group_by.class.label)]
    end

    content_tag :fieldset do
      legend = content_tag :legend, I18n.t("reporting.group_by.selected_#{type}"), class: 'hidden-for-sighted'

      container = content_tag :div,
                              id: "group-by--#{type}",
                              class: 'group-by--container grid-block',
                              'data-initially-selected': initially_selected.to_json.gsub('"', "'") do
        out = content_tag :span, class: 'group-by--caption grid-content shrink' do
          content_tag :span do
            I18n.t(:"label_#{type}")
          end
        end

        out += content_tag :span, '', id: "group-by--selected-#{type}", class: 'group-by--selected-elements grid-block'

        out += content_tag :span,
                           class: 'group-by--control grid-content shrink' do
          label = label_tag "group-by--add-#{type}",
                            I18n.t(:label_group_by_add) + ' ' +
                            I18n.t('js.filter.description.text_open_filter'),
                            class: 'hidden-for-sighted'

          label += content_tag :select, id: "group-by--add-#{type}", class: 'advanced-filters--select' do
            content = content_tag :option, I18n.t(:label_group_by_add), value: ''

            content += engine::GroupBy.all_grouped.sort_by do |label, _group_by_ary|
              I18n.t(label)
            end.map do |label, group_by_ary|
              content_tag :optgroup, label: h(I18n.t(label)) do
                render_options group_by_ary
              end
            end.join.html_safe
            content
          end

          label
        end

        out
      end

      legend + container
    end
  end

  def render
    write(content_tag(:div, id: 'group-by--area', class: 'autoscroll') do
      out =  render_group 'columns', @subject.group_bys(:column)
      out += render_group 'rows', @subject.group_bys(:row)
      out.html_safe
    end)
  end
end
