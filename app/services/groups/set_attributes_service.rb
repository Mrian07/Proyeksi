#-- encoding: UTF-8

module Groups
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_attributes(params)
      set_users(params) if params.key?(:user_ids)
      super
    end

    # We do not want to persist the associated users (members) in a
    # SetAttributesService. Therefore we are building the association here.
    #
    # Note that due to the way we handle members, via a specific AddUsersService
    # the group should no longer simply be saved after group_users have been added.
    def set_users(params)
      user_ids = (params.delete(:user_ids) || []).map(&:to_i)

      existing_user_ids = model.group_users.map(&:user_id)
      build_new_users user_ids - existing_user_ids
      mark_outdated_users existing_user_ids - user_ids
    end

    def build_new_users(new_user_ids)
      new_user_ids.each do |id|
        model.group_users.build(user_id: id)
      end
    end

    def mark_outdated_users(removed_user_ids)
      removed_user_ids.each do |id|
        model.group_users.find { |gu| gu.user_id == id }.mark_for_destruction
      end
    end
  end
end
