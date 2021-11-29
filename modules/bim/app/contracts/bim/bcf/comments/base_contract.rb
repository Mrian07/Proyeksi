

module Bim::Bcf
  module Comments
    class BaseContract < BaseContract
      attribute :issue
      attribute :viewpoint
      attribute :reply_to

      validate :user_allowed_to_manage_bcf
      validate :validate_viewpoint_reference
      validate :validate_reply_to_comment

      private

      def user_allowed_to_manage_bcf
        errors.add :base, :error_unauthorized unless @user.allowed_to?(:manage_bcf, model.issue.work_package.project)
      end

      def validate_viewpoint_reference
        errors.add(:viewpoint, :does_not_exist) if model.viewpoint.is_a?(::Bim::Bcf::NonExistentViewpoint)
      end

      def validate_reply_to_comment
        errors.add(:bcf_comment, :does_not_exist) if model.reply_to.is_a?(::Bim::Bcf::NonExistentComment)
      end
    end
  end
end
