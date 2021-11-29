#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Operators
        class QueryOperatorRepresenter < ::API::Decorators::Single
          self_link id_attribute: ->(*) { represented.to_query },
                    title_getter: ->(*) { name }

          def initialize(model, *_)
            super(model, current_user: nil, embed_links: true)
          end

          property :id,
                   exec_context: :decorator

          property :name,
                   exec_context: :decorator

          def name
            represented.human_name
          end

          def id
            represented.to_sym
          end

          def _type
            'QueryOperator'
          end
        end
      end
    end
  end
end
