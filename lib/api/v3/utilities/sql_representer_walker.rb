module API
  module V3
    module Utilities
      class SqlRepresenterWalker
        include API::Utilities::PageSizeHelper

        def initialize(scope,
                       current_user:,
                       url_query: {},
                       embed: {},
                       select: {},
                       self_path: nil)
          self.scope = scope
          self.current_user = current_user
          self.embed = embed
          self.select = select
          self.self_path = self_path
          self.url_query = url_query
        end

        def walk(start)
          result = SqlWalkerResults.new(scope,
                                        url_query: url_query,
                                        self_path: self_path)

          result.selects = embedded_depth_first([], start) do |map, stack, current_representer|
            result.replace_map.merge!(map)

            current_representer.select_sql(select_for(stack), result)
          end

          embedded_depth_first([], start) do |_, stack, current_representer|
            result.scope = current_representer.joins(select_for(stack), result.scope)
          end

          embedded_depth_first([], start) do |_, _, current_representer|
            result.ctes.merge!(current_representer.ctes(result))
          end

          self.sql = start.to_sql(result)

          self
        end

        def to_json(*)
          ActiveRecord::Base.connection.select_one(sql)['json']
        end

        protected

        attr_accessor :scope,
                      :current_user,
                      :embed,
                      :select,
                      :sql,
                      :url_query,
                      :self_path

        def embedded_depth_first(stack, current_representer, &block)
          up_map = {}

          embed_for(stack).each_key do |key|
            representer = current_representer
                            .embed_map[key]

            up_map[key] = embedded_depth_first(stack.dup << key, representer, &block)
          end

          yield up_map, stack, current_representer
        end

        def select_for(stack)
          stack.any? ? select.dig(*stack) : select
        end

        def embed_for(stack)
          stack.any? ? embed.dig(*stack) : embed
        end
      end
    end
  end
end
