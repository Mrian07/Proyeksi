#-- encoding: UTF-8



require 'task_list/filter'

module OpenProject::TextFormatting
  module Filters
    # Overwriting the gem class to roll with our own classes
    class TaskListFilter < ::TaskList::Filter
      # Copied and adapted from parent class
      #
      # Renders the item checkbox in a span including the item state.
      #
      # Returns an HTML-safe String.
      def render_item_checkbox(item)
        %(<input type="checkbox"
        class="op-uc-list--task-checkbox"
        #{'checked="checked"' if item.complete?}
        disabled="disabled"
      />)
      end

      # Copied and adapted from parent class.
      # The added css classes are adapted or removed.
      #
      # Filters the source for task list items.
      #
      # Each item is wrapped in HTML to identify, style, and layer
      # useful behavior on top of.
      #
      # Modifications apply to the parsed document directly.
      #
      # Returns nothing.
      def filter!
        list_items(doc).reverse.each do |li|
          next if list_items(li.parent).empty?

          add_css_class(li.parent, 'op-uc-list_task-list')

          outer, inner =
            if p = li.xpath(ItemParaSelector)[0]
              [p, p.inner_html]
            else
              [li, li.inner_html]
            end
          if match = (inner.chomp =~ ItemPattern && $1)
            item = TaskList::Item.new(match, inner)
            # prepend because we're iterating in reverse
            task_list_items.unshift item

            outer.inner_html = render_task_list_item(item)
          end
        end
      end
    end
  end
end
