

module Redmine
  module Acts
    module Attachable
      extend ActiveSupport::Concern

      included do
        extend ClassMethods
      end

      def self.attachables
        @attachables ||= []
      end

      module ClassMethods
        def acts_as_attachable(options = {})
          Redmine::Acts::Attachable.attachables.push(self)
          class_attribute :attachable_options
          set_acts_as_attachable_options(options)

          attachments_order = options.delete(:order) || "#{Attachment.table_name}.created_at"
          has_many :attachments, -> {
            order(attachments_order)
          }, **options.reverse_merge!(as: :container, dependent: :destroy)

          attr_accessor :attachments_replacements,
                        :attachments_claimed

          send :include, Redmine::Acts::Attachable::InstanceMethods
        end

        private

        def set_acts_as_attachable_options(options)
          self.attachable_options = {
            view_permission: view_permission(options),
            delete_permission: delete_permission(options),
            add_on_new_permission: add_on_new_permission(options),
            add_on_persisted_permission: add_on_persisted_permission(options),
            only_user_allowed: only_user_allowed(options),
            viewable_by_all_users: viewable_by_all_users(options),
            modification_blocked: options[:modification_blocked],
            extract_tsv: attachable_extract_tsv_option(options)
          }

          # Because subclasses can have their own attachable_options,
          # we ensure those are also listed.
          Redmine::Acts::Attachable.attachables.push(self) unless Redmine::Acts::Attachable.attachables.include?(self)

          options.except!(:view_permission,
                          :delete_permission,
                          :add_on_new_permission,
                          :add_on_persisted_permission,
                          :add_permission,
                          :only_user_allowed,
                          :viewable_by_all_users,
                          :modification_blocked,
                          :extract_tsv)
        end

        def view_permission(options)
          options[:view_permission] || view_permission_default
        end

        def delete_permission(options)
          options[:delete_permission] || edit_permission_default
        end

        def add_on_new_permission(options)
          options[:add_on_new_permission] || options[:add_permission] || edit_permission_default
        end

        def add_on_persisted_permission(options)
          options[:add_on_persisted_permission] || options[:add_permission] || edit_permission_default
        end

        def viewable_by_all_users(options)
          options.fetch(:viewable_by_all_users, false)
        end

        def only_user_allowed(options)
          options.fetch(:only_user_allowed, false)
        end

        def view_permission_default
          "view_#{name.pluralize.underscore}".to_sym
        end

        def edit_permission_default
          "edit_#{name.pluralize.underscore}".to_sym
        end

        def attachable_extract_tsv_option(options)
          options.fetch(:extract_tsv, false)
        end
      end

      module InstanceMethods
        extend ActiveSupport::Concern

        included do
          after_save :persist_attachments_claimed

          validate :validate_attachments_claimable

          include InstanceMethods
        end

        class_methods do
          def attachments_addable?(user = User.current)
            user.allowed_to_globally?(attachable_options[:add_on_new_permission]) ||
              user.allowed_to_globally?(attachable_options[:add_on_persisted_permission])
          end

          def attachment_tsv_extracted?
            attachable_options[:extract_tsv]
          end
        end

        module InstanceMethods
          def modification_blocked?
            if (policy = self.class.attachable_options[:modification_blocked])
              return instance_eval &policy
            end

            false
          end

          def attachments_visible?(user = User.current)
            return true if user.logged? && self.class.attachable_options[:viewable_by_all_users]

            allowed_to_on_attachment?(user, self.class.attachable_options[:view_permission])
          end

          def attachments_deletable?(user = User.current)
            return false if modification_blocked?

            allowed_to_on_attachment?(user, self.class.attachable_options[:delete_permission])
          end

          def attachments_addable?(user = User.current)
            return false if modification_blocked?

            (new_record? && allowed_to_on_attachment?(user, self.class.attachable_options[:add_on_new_permission])) ||
              (persisted? && allowed_to_on_attachment?(user, self.class.attachable_options[:add_on_persisted_permission]))
          end

          private

          def allowed_to_on_attachment?(user, permissions)
            Array(permissions).any? do |permission|
              if respond_to?(:project)
                user.allowed_to?(permission, project)
              else
                user.allowed_to_globally?(permission)
              end
            end
          end

          def persist_attachments_claimed
            return unless claimed_attachments?

            Attachment
              .where(id: attachments_claimed.map(&:id))
              .update_all(container_id: id, container_type: attachable_class.name)

            attachments_claimed.clear

            attachments.reload
          end

          def attachable_class
            (Redmine::Acts::Attachable.attachables & self.class.ancestors).first
          end

          def validate_attachments_claimable
            return unless claimed_attachments?

            if !attachments_addable?
              errors.add :attachments, :not_allowed
            elsif claimed_attachments_of_other_author?
              errors.add :attachments, :does_not_exist
            elsif claimed_attachments_already_claimed?
              errors.add :attachments, :unchangeable
            end
          end

          def claimed_attachments?
            attachments_claimed&.any?
          end

          def claimed_attachments_of_other_author?
            attachments_claimed.any? { |a| a.author != User.current }
          end

          def claimed_attachments_already_claimed?
            attachments_claimed.any?(&:containered?)
          end
        end
      end
    end
  end
end
