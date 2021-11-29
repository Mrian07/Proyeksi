#-- encoding: UTF-8



module OAuth
  ##
  # Base controller for doorkeeper to skip the login check
  # because it needs to set a specific return URL
  # See config/initializers/doorkeeper.rb
  class AuthBaseController < ::ApplicationController
    # Ensure we prepend the CSP extension
    # before any other action is being performed
    prepend_before_action :extend_content_security_policy

    skip_before_action :check_if_login_required
    layout 'only_logo'

    def extend_content_security_policy
      return unless pre_auth&.authorizable?

      additional_form_actions = application_redirect_uris
      return if additional_form_actions.empty?

      flash[:_csp_appends] = { form_action: additional_form_actions }
      append_content_security_policy_directives flash[:_csp_appends]
    end

    def application_redirect_uris
      pre_auth&.client&.application&.redirect_uri
        .to_s
        .split
        .select { |url| url.start_with?('http') }
        .map { |url| URI.join(url, '/').to_s }
    end
  end
end
