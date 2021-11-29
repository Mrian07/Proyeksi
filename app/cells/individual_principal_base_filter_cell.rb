

class IndividualPrincipalBaseFilterCell < RailsCell
  include UsersHelper
  include ActionView::Helpers::FormOptionsHelper

  class << self
    def query(params)
      q = base_query.new

      apply_filters(params, q)

      q
    end

    def filter(params)
      query(params).results
    end

    def filtered?(params)
      %i(name status group_id role_id).any? { |name| params[name].present? }
    end

    def filter_name(query, name)
      if name.present?
        query.where(:any_name_attribute, '~', name)
      end
    end

    def filter_group(query, group_id)
      if group_id.present?
        query.where(:group, '=', group_id)
      end
    end

    def filter_role(query, role_id)
      if role_id.present?
        query.where(:role_id, '=', role_id)
      end
    end

    def filter_project(query, project_id)
      if project_id.present?
        query.where(:project_id, '=', project_id)
      end
    end

    def base_query
      raise NotImplementedError
    end

    protected

    def apply_filters(params, query)
      filter_project query, params[:project_id]
      filter_name query, params[:name]
      filter_group query, params[:group_id]
      filter_role query, params[:role_id]

      query
    end
  end

  # INSTANCE METHODS:

  def filter_path
    raise NotImplementedError
  end

  def initially_visible?
    true
  end

  def has_close_icon?
    false
  end

  def has_statuses?
    defined?(status)
  end

  def has_groups?
    defined?(groups) && groups.present?
  end

  def params
    model
  end
end
