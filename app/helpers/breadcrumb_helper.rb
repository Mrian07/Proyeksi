#-- encoding: UTF-8



module BreadcrumbHelper
  def full_breadcrumb
    breadcrumb_list(*breadcrumb_paths)
  end

  def breadcrumb(*args)
    elements = args.flatten
    elements.any? ? content_tag('p', (args.join(' &#187; ') + ' &#187; ').html_safe, class: 'op-breadcrumb') : nil
  end

  def breadcrumb_list(*args)
    elements = args.flatten
    breadcrumb_elements = [content_tag(:li,
                                       elements.shift.to_s,
                                       class: 'first-breadcrumb-element')]

    breadcrumb_elements += elements.map do |element|
      if element
        content_tag(:li,
                    h(element.to_s),
                    class: "icon4 icon-small icon-arrow-right5")
      end
    end

    content_tag(:ul, breadcrumb_elements.join.html_safe, class: 'op-breadcrumb',  'data-qa-selector': 'op-breadcrumb')
  end

  def breadcrumb_paths(*args)
    if args.nil?
      nil
    elsif args.empty?
      @breadcrumb_paths ||= [default_breadcrumb]
    else
      @breadcrumb_paths ||= []
      @breadcrumb_paths += args
    end
  end

  def show_breadcrumb
    if !!(defined? show_local_breadcrumb)
      show_local_breadcrumb
    else
      false
    end
  end
end
