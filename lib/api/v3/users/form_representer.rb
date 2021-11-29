#-- encoding: UTF-8



module API
  module V3
    module Users
      class FormRepresenter < ::API::Decorators::SimpleForm
        def model
          User
        end
      end
    end
  end
end
