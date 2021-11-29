

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('config/environment', __dir__)

subdir = OpenProject::Configuration.rails_relative_url_root.presence

map (subdir || '/') do
  use Rack::Protection::JsonCsrf
  use Rack::Protection::FrameOptions

  run OpenProject::Application
end
