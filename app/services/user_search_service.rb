#-- encoding: UTF-8

class UserSearchService
  attr_accessor :params
  attr_reader :users_only, :project

  SEARCH_SCOPES = [
    'project_id',
    'ids',
    'group_id',
    'status',
    'name'
  ]

  def initialize(params, users_only: false)
    self.params = params

    @users_only = users_only
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def scope
    if users_only
      project.nil? ? User : project.users.user
    else
      project.nil? ? Principal : project.principals.human
    end
  end

  def search
    params[:ids].present? ? ids_search(scope) : query_search(scope)
  end

  def ids_search(scope)
    ids = params[:ids].split(',')

    scope.where(id: ids)
  end

  def query_search(scope)
    scope = scope.in_group(params[:group_id].to_i) if params[:group_id].present?
    c = ARCondition.new

    case params[:status]
    when 'blocked'
      @status = :blocked
      scope = scope.blocked
    when 'all'
      @status = :all
      # No scope change necessary
    else
      @status = params[:status] ? params[:status].to_i : User.statuses[:active]
      scope = scope.not_blocked if users_only && @status == User.statuses[:active]
      c << ['status = ?', @status]
    end

    unless params[:name].blank?
      name = "%#{params[:name].strip.downcase}%"
      c << ['LOWER(login) LIKE ? OR LOWER(firstname) LIKE ? OR LOWER(lastname) LIKE ? OR LOWER(mail) LIKE ?', name, name, name,
            name]
    end

    scope.where(c.conditions)
    # currently, the sort/paging-helpers are highly dependent on being included in a controller
    # and having access to things like the session or the params: this makes it harder
    # to test outside a controller and especially hard to re-use this functionality
    # .page(page_param)
    # .per_page(per_page_param)
    # .order(sort_clause)
  end
end
