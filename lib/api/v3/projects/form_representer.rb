#-- encoding: UTF-8



module API
  module V3
    module Projects
      class FormRepresenter < ::API::Decorators::SimpleForm
        def model
          Project
        end
      end
    end
  end
end
