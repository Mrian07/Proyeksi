

Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.env.production?
    provider :developer, fields: %i[first_name last_name email]
  end
end
