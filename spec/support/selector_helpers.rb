

module SelectorHelpers
  module_function

  def get_pseudo_class_property(page, node, pseudo_class, property)
    page.evaluate_script('window.getComputedStyle(' + element_by_node(node) + ', "' +
                                                  pseudo_class +
                         '").getPropertyValue("' + property + '")')
  end

  def element_by_node(node)
    'document.evaluate("' + node.path + '", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue'
  end
end
