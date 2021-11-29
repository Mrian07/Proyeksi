#-- encoding: UTF-8



module API
  module V3
    module Capabilities
      module Contexts
        class GlobalRepresenter < ::API::Decorators::Single
          link :self do
            api_v3_paths.capabilities_contexts_global
          end

          property :id,
                   getter: ->(*) { 'global' }

          def _type
            'CapabilityContext'
          end

          def model_required?
            false
          end
        end
      end
    end
  end
end
