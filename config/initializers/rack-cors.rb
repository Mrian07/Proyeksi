#-- encoding: UTF-8


Rails.application.config.middleware.insert_after Rails::Rack::Logger, Rack::Cors do
  allow do
    origins { |source, _env| ::API::V3::CORS.allowed?(source) }
    resource '/api/v3*',
             headers: :any,
             methods: :any,
             credentials: true,
             if: proc { ::API::V3::CORS.enabled? }

    resource '/oauth/*',
             headers: :any,
             methods: :any,
             credentials: true,
             if: proc { ::API::V3::CORS.enabled? }
  end
end
