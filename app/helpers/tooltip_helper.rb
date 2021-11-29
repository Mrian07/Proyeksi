#-- encoding: UTF-8



module TooltipHelper
  include OpenProject::FormTagHelper

  ##
  # Render a tooltip span
  #
  # @param text [string] Content of the tooltip
  # @param placement [string] placement (top, left, right, bottom)
  # @param span_classes [string] Additional classes on the span
  # @param icon [string] icon class
  def tooltip_tag(text, placement: 'left', icon: 'icon-help', span_classes: nil)
    content_tag :span,
                class: "tooltip--#{placement} #{span_classes}",
                data: { tooltip: text } do
      op_icon "icon #{icon}"
    end
  end
end
