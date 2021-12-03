#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class SanitizationFilter < HTML::Pipeline::SanitizationFilter
      def whitelist
        base = super

        Sanitize::Config.merge(
          base,
          elements: base[:elements] + %w[macro mention],

          attributes: base[:attributes].deep_merge(
            # Whitelist class and data-* attributes on all macros
            'macro' => ['class', :data],
            # mentions
            'mention' => %w[data-type data-text data-id class],
            # add styles to tables
            'figure' => ['class', 'style'],
            'table' => ['style'],
            'th' => ['style'],
            'tr' => ['style'],
            'td' => ['style']
          ),

          # Add rel attribute to prevent tabnabbing
          add_attributes: {
            'a' => { 'rel' => 'noopener noreferrer' }
          },

          # Add custom transformer logic for more complex modifications
          transformers: base[:transformers] + transformers,

          # Allow relaxed CSS styles for the given attributes
          css: ::Sanitize::Config::RELAXED[:css]
        )
      end

      private

      def transformers
        [
          todo_list_transformer,
          code_block_transformer
        ]
      end

      # Transformer to fix task lists in sanitization
      # Replace to do lists in tables with their markdown equivalent
      def todo_list_transformer
        lambda { |env|
          name = env[:node_name]
          table = env[:node]

          next unless name == 'table'

          # Support both the old css ('todo-list__label') as well as the new one
          # ('op-uc-list_task-list').
          table.css('label.todo-list__label, .op-uc-list_task-list label').each do |label|
            # table.css('.op-uc-list_task-list label').each do |label|
            checkbox = label.css('input[type=checkbox]').first
            li_node = label.ancestors.detect { |node| node.name == 'li' }

            # assign all children of the label to its parent
            # that might be the LI, or another element (code, link)
            parent = label.parent

            # CKEditor splits text nodes within task lists so that there are multiple labels
            # but only the first has a checkbox
            # e.g., - [ ] Foo [Bar](https://example.com)
            # both Foo and Bar are contained by labels
            if checkbox.nil?
              # In case we don't have a checkbox, add the content of the label
              # or it's parent in case of links directly to the node
              to_add = li_node == parent ? label.children : parent
              li_node.add_child to_add
            else
              checked = checkbox.attr('checked') == 'checked' ? 'x' : ' '
              checkbox.unlink

              # Ensure the task list text is be added as first child to the LI
              li_node.prepend_child " [#{checked}] "

              # Prepend if there is a parent in between
              if parent == li_node
                parent.add_child label.children
              else
                parent.prepend_child label.children
              end
            end
          end
        }
      end

      # Prevent nested pre + code.
      # In such a case, the code is removed.
      def code_block_transformer
        lambda { |env|
          name = env[:node_name]
          code = env[:node]

          next unless name == 'code'

          parent = code.parent

          if parent&.name == 'pre'
            parent.children = code.children
          end
        }
      end
    end
  end
end
