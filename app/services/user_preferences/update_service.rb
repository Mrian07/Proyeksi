#-- encoding: UTF-8

module UserPreferences
  class UpdateService < ::BaseServices::Update
    protected

    attr_accessor :notifications

    def validate_params(params)
      contract = ParamsContract.new(model, user, params: params)

      ServiceResult.new success: contract.valid?,
                        errors: contract.errors,
                        result: model
    end

    def before_perform(params, _service_result)
      self.notifications = params&.delete(:notification_settings)

      super
    end

    def after_perform(service_call)
      return service_call if notifications.nil?

      inserted = persist_notifications
      remove_other_notifications(inserted)

      service_call
    end

    def persist_notifications
      global, project = notifications
                          .map { |item| item.merge(user_id: model.user_id) }
                          .partition { |setting| setting[:project_id].nil? }

      global_ids = upsert_notifications(global, %i[user_id], 'project_id IS NULL')
      project_ids = upsert_notifications(project, %i[user_id project_id], 'project_id IS NOT NULL')

      global_ids + project_ids
    end

    def remove_other_notifications(ids)
      NotificationSetting
        .where(user_id: model.user_id)
        .where.not(id: ids)
        .delete_all
    end

    ##
    # Upsert notification while respecting the partial index on notification_settings
    # depending on the project presence
    #
    # @param notifications The array of notification hashes to upsert
    # @param conflict_target The uniqueness constraint to upsert within
    # @param index_predicate The partial index condition on the project
    def upsert_notifications(notifications, conflict_target, index_predicate)
      return [] if notifications.empty?

      NotificationSetting
        .import(
          notifications,
          on_duplicate_key_update: {
            conflict_target: conflict_target,
            index_predicate: index_predicate,
            columns: %i[watched
                        involved
                        mentioned
                        work_package_commented
                        work_package_created
                        work_package_processed
                        work_package_prioritized
                        work_package_scheduled
                        news_added
                        news_commented
                        document_added
                        forum_messages
                        wiki_page_added
                        wiki_page_updated
                        membership_added
                        membership_updated]
          },
          validate: false
        ).ids
    end
  end
end
