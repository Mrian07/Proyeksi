

if OpenProject::Configuration.blacklisted_routes.any?
  # Block logins from a bad user agent
  Rack::Attack.blocklist('block forbidden routes') do |req|
    regex = OpenProject::Configuration.blacklisted_routes.map! { |str| Regexp.new(str) }
    regex.any? { |i| i =~ req.path }
  end

  Rack::Attack.blocklisted_response = lambda do |_env|
    # All blacklisted routes would return a 404.
    [404, {}, ['Not found']]
  end
end
