#-- encoding: UTF-8



module Members
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_attributes(params)
      assign_roles(params)

      super
    end

    def assign_roles(params)
      return unless params[:role_ids]

      role_ids = params
        .delete(:role_ids)
        .select(&:present?)
        .map(&:to_i)

      existing_ids = model.member_roles.map(&:role_id)

      mark_roles_for_destruction(existing_ids - role_ids)
      build_roles(role_ids - existing_ids)
    end

    def mark_roles_for_destruction(role_ids)
      role_ids.each do |role_id|
        model
          .member_roles
          .detect { |mr| mr.inherited_from.nil? && mr.role_id == role_id }
          &.mark_for_destruction
      end
    end

    def build_roles(role_ids)
      role_ids.each do |role_id|
        model.member_roles.build(role_id: role_id)
      end
    end
  end
end
