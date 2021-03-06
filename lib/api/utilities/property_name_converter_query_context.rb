#-- encoding: UTF-8

module API
  module Utilities
    # The PropertyNameConverter checks whether the object responds to the attribute
    # that is to be converted.
    # If the context is Query (e.g. when filters are restored), a WorkPackage
    # is used instead.  However, some of the methods a work package does not
    # respond to are nevertheless valid for transformation.  We therefore
    # delegate to a WorkPackage per default but also explicitly respond in some
    # cases.
    class PropertyNameConverterQueryContext < SimpleDelegator
      def initialize
        super(WorkPackage.new)
      end

      def subproject_id; end
    end
  end
end
