

class Widget::Settings::Fieldset < Widget::Base
  dont_cache!

  def render_with_options(options, &block)
    @type = options.delete(:type) || 'filter'
    @id = @type.to_s
    @label = :"label_#{@type}"
    super(options, &block)
  end

  def render
    hash = self.hash
    write(content_tag(:fieldset,
                      id: @id,
                      class: 'form--fieldset -collapsible') do
            html = content_tag(:legend,
                               show_at_id: hash.to_s,
                               icon: "#{@type}-legend-icon",
                               tooltip: "#{@type}-legend-tip",
                               class: 'form--fieldset-legend',
                               id: hash.to_s) do
              content_tag(:a, href: '#') { I18n.t(@label) }
            end
            html + yield
          end)
  end
end
