#-- encoding: UTF-8



module ReorderLinksHelper
  def reorder_links(name, url, options = {})
    method = options[:method] || :post

    content_tag(:span,
                reorder_link(name, url, 'highest', 'icon-sort-up', t(:label_sort_highest), method) +
                  reorder_link(name, url, 'higher', 'icon-arrow-up2', t(:label_sort_higher), method) +
                  reorder_link(name, url, 'lower', 'icon-arrow-down2', t(:label_sort_lower), method) +
                  reorder_link(name, url, 'lowest', 'icon-sort-down', t(:label_sort_lowest), method),
                class: 'reorder-icons')
  end

  def reorder_link(name, url, direction, icon_class, label, method)
    text = content_tag(:span,
                       label,
                       class: 'hidden-for-sighted')
    icon = content_tag(:span,
                       '',
                       class: "icon-context #{icon_class} icon-small")
    link_to(text + icon,
            url.merge("#{name}[move_to]" => direction),
            method: method,
            title: label)
  end
end
