#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      class WorkPackageLockVersionPayloadRepresenter < ::API::Decorators::Single
        include ::API::Utilities::PayloadRepresenter

        property :lock_version,
                 render_nil: true,
                 getter: ->(*) {
                   lock_version.to_i
                 }
      end
    end
  end
end
