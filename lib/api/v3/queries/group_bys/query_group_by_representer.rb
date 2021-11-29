#-- encoding: UTF-8



module API
  module V3
    module Queries
      module GroupBys
        class QueryGroupByRepresenter < ::API::Decorators::Single
          include API::Utilities::RepresenterToJsonCache

          self_link id_attribute: ->(*) { converted_name },
                    title_getter: ->(*) { represented.caption }
          def initialize(model, *_)
            super(model, current_user: nil, embed_links: true)
          end

          property :id,
                   exec_context: :decorator

          property :caption,
                   as: :name

          def converted_name
            convert_attribute(represented.name)
          end

          alias :id :converted_name

          def _type
            'QueryGroupBy'
          end

          def convert_attribute(attribute)
            ::API::Utilities::PropertyNameConverter.from_ar_name(attribute)
          end

          def json_cache_key
            [represented.name, represented.caption]
          end
        end
      end
    end
  end
end
