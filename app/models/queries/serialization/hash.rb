module Queries
  module Serialization
    module Hash
      extend ActiveSupport::Concern

      class_methods do
        def from_hash(hash)
          new(user: hash[:user]).tap do |query|
            query.add_filters hash[:filters] if hash[:filters].present?
            query.order hash[:orders] if hash[:orders].present?
            query.group hash[:group_by] if hash[:group_by].present?
          end
        end
      end

      def to_hash
        {
          filters: filters.map { |f| { name: f.name, operator: f.operator, values: f.values } },
          orders: orders.to_h { |o| [o.attribute, o.direction] },
          group_by: group_by,
          user: user
        }
      end

      def add_filters(filters)
        filters.each do |f|
          where(f[:name], f[:operator], f[:values])
        end
      end
    end
  end
end
