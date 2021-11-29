#-- encoding: UTF-8



module API
  module V3
    module CustomActions
      class CustomActionExecuteRepresenter < ::API::Decorators::Single
        include API::Decorators::LinkedResource

        # For now, this is only intended for parsing
        associated_resource :work_package,
                            link: ->(*) {
                              raise NotImplementedError
                            },
                            getter: ->(*) {
                              raise NotImplementedError
                            }

        property :lock_version
      end
    end
  end
end
