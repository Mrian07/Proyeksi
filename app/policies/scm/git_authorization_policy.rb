class SCM::GitAuthorizationPolicy < SCM::AuthorizationPolicy
  private

  def readonly_request?(params)
    uri = params[:uri]
    location = params[:location]

    !%r{^#{location}/*[^/]+/+(info/refs\?service=)?git-receive-pack$}o.match(uri)
  end
end
