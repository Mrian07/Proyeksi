#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Filters
        class QueryFilterRepresenter < ::API::Decorators::Single
          self_link id_attribute: ->(*) { converted_key },
                    title_getter: ->(*) { represented.human_name },
                    path: :query_filter

          def initialize(model, *_)
            super(model, current_user: nil, embed_links: true)
          end

          property :id,
                   exec_context: :decorator

          def converted_key
            convert_attribute(represented.name)
          end

          alias :id :converted_key

          def _type
            'QueryFilter'
          end

          def convert_attribute(attribute)
            ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
          end
        end
      end
    end
  end
end
