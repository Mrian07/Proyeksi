#-- encoding: UTF-8

module API
  module V3
    module Memberships
      class UpdateFormRepresenter < FormRepresenter
        include API::Decorators::UpdateForm

        def downcase_model_name
          'membership'
        end
      end
    end
  end
end
