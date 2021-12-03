class SCM::SubversionAuthorizationPolicy < SCM::AuthorizationPolicy
  private

  def readonly_request?(params)
    method = params[:method]
    %w(GET PROPFIND REPORT OPTIONS).include?(method)
  end
end
