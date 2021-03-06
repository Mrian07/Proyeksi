#-- encoding: UTF-8

module API
  module V3
    module Memberships
      class CreateFormRepresenter < FormRepresenter
        include API::Decorators::CreateForm

        def downcase_model_name
          'membership'
        end
      end
    end
  end
end
