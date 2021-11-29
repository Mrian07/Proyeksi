#-- encoding: UTF-8



# Provides aliases to hierarchy_*
# methods to stay compatible with code written for awesome_nested_set

module WorkPackage::TypedDagDefaults
  extend ActiveSupport::Concern

  included do
    # Can't use .alias here
    # as the dag methods are mixed in later

    def leaves
      hierarchy_leaves
    end

    def self.leaves
      hierarchy_leaves
    end

    def leaf?
      # The leaf? implementation relies on the children relations. If that relation is not loaded,
      # rails will attempt to do the performant check on whether such a relation exists at all. While
      # This is performant for one call, subsequent calls have to again fetch from the db (cached admittedly)
      # as the relations are still not loaded.
      # For reasons I could not find out, adding a #reload method here lead to the virtual attribute management for parent
      # to no longer work. Resetting the @is_leaf method was hence moved to the WorkPackage::Parent module
      @is_leaf ||= hierarchy_leaf?
    end

    def root
      hierarchy_roots.first
    end

    def self.roots
      hierarchy_roots
    end

    def root?
      hierarchy_root?
    end

    private

    def reset_is_leaf
      @is_leaf = nil
    end
  end
end
