#-- encoding: UTF-8



class Authorization::EnterpriseService
  attr_accessor :token

  GUARDED_ACTIONS = %i(
    define_custom_style
    multiselect_custom_fields
    edit_attribute_groups
    work_package_query_relation_columns
    attribute_help_texts
    two_factor_authentication
    ldap_groups
    custom_fields_in_projects_list
    custom_actions
    conditional_highlighting
    readonly_work_packages
    attachment_filters
    board_view
    grid_widget_wp_graph
    placeholder_users
  ).freeze

  def initialize(token)
    self.token = token
  end

  # Return a true ServiceResult if the token contains this particular action.
  def call(action)
    allowed =
      if token.nil? || token.token_object.nil? || token.expired?
        false
      else
        process(action)
      end

    result(allowed)
  end

  private

  def process(action)
    # Every non-expired token
    GUARDED_ACTIONS.include?(action)
  end

  def result(bool)
    ServiceResult.new(success: bool, result: bool)
  end
end
