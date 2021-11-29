#-- encoding: UTF-8



module Bim::Bcf
  module Concerns
    module ManageBcfGuarded
      extend ActiveSupport::Concern

      included do
        validate :validate_user_allowed_to_manage

        private

        def validate_user_allowed_to_manage
          unless model.project && user.allowed_to?(:manage_bcf, model.project)
            errors.add :base, :error_unauthorized
          end
        end
      end
    end
  end
end
