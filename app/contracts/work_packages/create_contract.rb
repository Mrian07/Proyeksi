#-- encoding: UTF-8



require 'work_packages/base_contract'

module WorkPackages
  class CreateContract < BaseContract
    attribute :author_id,
              writeable: false do
      errors.add :author_id, :invalid if model.author != user
    end

    default_attribute_permission :add_work_packages

    validate :user_allowed_to_add

    private

    def user_allowed_to_add
      if (model.project && !@user.allowed_to?(:add_work_packages, model.project)) ||
         !@user.allowed_to?(:add_work_packages, nil, global: true)

        errors.add :base, :error_unauthorized
      end
    end

    def attributes_changed_by_user
      # lock version is initialized by AR itself
      super - ['lock_version']
    end
  end
end
