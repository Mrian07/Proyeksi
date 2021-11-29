

module API
  module Decorators
    class SqlCollectionRepresenter
      include API::Decorators::Sql::Hal

      class << self
        def ctes(walker_result)
          {
            all_elements: walker_result.scope.to_sql,
            page_elements: "SELECT * FROM all_elements LIMIT #{sql_limit(walker_result)} OFFSET #{sql_offset(walker_result)}",
            total: "SELECT COUNT(*) from all_elements"
          }
        end

        private

        def select_from(walker_result)
          "page_elements"
        end

        def full_self_path(walker_results, overrides = {})
          "#{walker_results.self_path}?#{href_query(walker_results, overrides)}"
        end

        def href_query(walker_results, overrides)
          walker_results.url_query.merge(overrides).to_query
        end

        def sql_offset(walker_result)
          (walker_result.offset - 1) * walker_result.page_size
        end

        def sql_limit(walker_result)
          walker_result.page_size
        end
      end

      property :_type,
               representation: ->(*) { "'Collection'" }

      property :count,
               representation: ->(*) { "COUNT(*)" }

      property :total,
               representation: ->(*) { "(SELECT * from total)" }

      property :pageSize,
               representation: ->(walker_result) { walker_result.page_size }

      property :offset,
               representation: ->(walker_result) { walker_result.offset }

      link :self,
           href: ->(walker_result) { "'#{full_self_path(walker_result)}'" },
           title: -> { nil }

      link :jumpTo,
           href: ->(walker_result) { "'#{full_self_path(walker_result, offset: '{offset}')}'" },
           title: -> { nil },
           templated: true

      link :changeSize,
           href: ->(walker_result) { "'#{full_self_path(walker_result, pageSize: '{size}')}'" },
           title: -> { nil },
           templated: true

      link :previousByOffset,
           href: ->(walker_result) { "'#{full_self_path(walker_result, offset: walker_result.offset - 1)}'" },
           render_if: ->(walker_result) { walker_result.offset > 1 },
           title: -> { nil }

      link :nextByOffset,
           href: ->(walker_result) { "'#{full_self_path(walker_result, offset: walker_result.offset + 1)}'" },
           render_if: ->(walker_result) { "#{walker_result.offset * walker_result.page_size} < (SELECT * FROM total)" },
           title: -> { nil }

      embedded :elements,
               representation: ->(walker_result) do
                 "json_agg(#{walker_result.replace_map['elements']})"
               end
    end
  end
end
