

##
# Accepts option :content, which expects an enumerable of [name, id, *args]
# as it would appear in a filters available values. If given, it renders the
# option-tags from the content array instead of the filters available values.
# make sure to require Widget::Filters::Base first because otherwise
# ruby might find Base within Widget and Rails will not load it
require_dependency 'widget/filters/base'
class Widget::Filters::Option < Widget::Filters::Base
  def render
    first = true
    write((@options[:content] || filter_class.available_values).map do |name, id, *args|
      options = args.first || {} # optional configuration for values
      level = options[:level] # nesting_level is optional for values
      name = I18n.t(name) if name.is_a? Symbol
      name = name.empty? ? I18n.t(:label_none) : name
      name_prefix = (level && level > 0 ? (' ' * 2 * level + '> ') : '')
      if options[:optgroup]
        tag :optgroup, label: I18n.t(:label_sector)
      else
        opts = { value: id }
        if (Array(filter.values).map(&:to_s).include? id.to_s) || (first && Array(filter.values).empty?)
          opts[:selected] = 'selected'
        end
        first = false
        content_tag(:option, opts) { name_prefix + name }
      end
    end.join.html_safe)
  end
end
