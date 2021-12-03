class UserFilterCell < IndividualPrincipalBaseFilterCell
  options :groups, :status, :roles, :clear_url, :project

  class << self
    ##
    # Returns the selected status from the parameters
    # or the default status to be filtered by (all)
    # if no status is given.
    def status_param(params)
      params[:status].presence || 'all'
    end

    def filter_status(query, status)
      return unless status && status != 'all'

      case status
      when 'blocked'
        query.where(:blocked, '=', :blocked)
      when 'active'
        query.where(:status, '=', status.to_sym)
        query.where(:blocked, '!', :blocked)
      else
        query.where(:status, '=', status.to_sym)
      end
    end

    def base_query
      Queries::Users::UserQuery
    end


    protected

    def apply_filters(params, query)
      super(params, query)
      filter_status query, status_param(params)

      query
    end
  end

  # INSTANCE METHODS:

  def filter_path
    users_path
  end

  def user_status_options
    users_status_options_for_select status, extra: extra_user_status_options
  end

  def extra_user_status_options
    {}
  end
end
