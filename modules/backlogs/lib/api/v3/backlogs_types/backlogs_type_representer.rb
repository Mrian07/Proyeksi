

module API
  module V3
    module BacklogsTypes
      class BacklogsTypeRepresenter < ::API::Decorators::Single
        self_link path: :backlogs_type,
                  id_attribute: ->(*) { represented.last },
                  title_getter: ->(*) { represented.first }

        property :id,
                 exec_context: :decorator

        property :name,
                 exec_context: :decorator

        def _type
          "BacklogsType"
        end

        def id
          represented.last
        end

        def name
          represented.first
        end
      end
    end
  end
end
