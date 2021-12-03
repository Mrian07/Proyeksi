module Groups::Concerns
  module MembershipManipulation
    extend ActiveSupport::Concern

    def after_validate(params, _call)
      params ||= {}

      with_error_handled do
        ::Group.transaction do
          exec_query!(params, params.fetch(:send_notifications, true), params[:message])
        end
      end
    end

    private

    def with_error_handled
      yield
      ServiceResult.new success: true, result: model
    rescue StandardError => e
      Rails.logger.error { "Failed to modify members and associated roles of group #{model.id}: #{e} #{e.message}" }
      ServiceResult.new(success: false,
                        message: I18n.t(:notice_internal_server_error, app_title: Setting.app_title))
    end

    def exec_query!(params, send_notifications, message)
      affected_member_ids = modify_members_and_roles(params)

      touch_updated(affected_member_ids)

      send_notifications(affected_member_ids, message) if affected_member_ids.any? && send_notifications
    end

    def modify_members_and_roles(_params)
      raise NotImplementedError
    end

    def execute_query(query)
      ::Group
        .connection
        .exec_query(query)
        .rows
        .flatten
    end

    def touch_updated(member_ids)
      Member
        .where(id: member_ids)
        .touch_all
    end

    def send_notifications(member_ids, message)
      Notifications::GroupMemberAlteredJob.perform_later(member_ids, message)
    end
  end
end
