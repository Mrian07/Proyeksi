#-- encoding: UTF-8



# When included, it adds the ability to rebuild nested sets, thus fixing
# corrupted trees.
#
# AwesomeNestedSet has this functionality as well but it fixes the sets with
# running the callbacks defined in the model. This has two drawbacks:
#
# * It is prone to fail when a validation fails that has nothing to do with
# nested sets.
# * It is slow.
#
# The methods included are purely sql based. The code in here is partly copied
# over from awesome_nested_set's non sql methods.

module OpenProject::NestedSet::RebuildPatch
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Rebuilds the left & rights if unset or invalid.  Also very useful for converting from acts_as_tree.
    # Very similar to original nested_set implementation but uses update_all so that callbacks are not triggered
    def rebuild_silently!(roots = nil)
      # Don't rebuild a valid tree.
      return true if valid?

      scope = lambda { |_node| }
      if acts_as_nested_set_options[:scope]
        scope = lambda { |node|
          scope_column_names.inject('') do |str, column_name|
            str << "AND #{connection.quote_column_name(column_name)} = #{connection.quote(node.send(column_name.to_sym))} "
          end
        }
      end

      # setup index

      indices = Hash.new do |h, k|
        h[k] = 0
      end

      set_left_and_rights = lambda { |node|
        # set left
        node[left_column_name] = indices[scope.call(node)] += 1
        # find
        children = where(["#{quoted_parent_column_name} = ? #{scope.call(node)}", node])
                   .order([quoted_left_column_name,
                           quoted_right_column_name,
                           acts_as_nested_set_options[:order]].compact.join(', '))

        children.each { |n| set_left_and_rights.call(n) }

        # set right
        node[right_column_name] = indices[scope.call(node)] += 1

        changes = node.changes.inject({}) do |hash, (attribute, _values)|
          hash[attribute] = node.send(attribute.to_s)
          hash
        end

        where(id: node.id).update_all(changes) unless changes.empty?
      }

      # Find root node(s)
      # or take provided
      root_nodes = if roots.is_a? Array
                     roots
                   elsif roots.present?
                     [roots]
                   else
                     where("#{quoted_parent_column_name} IS NULL")
                     .order([quoted_left_column_name,
                             quoted_right_column_name,
                             acts_as_nested_set_options[:order]].compact.join(', '))
                   end

      root_nodes.each do |root_node|
        set_left_and_rights.call(root_node)
      end
    end
  end
end
