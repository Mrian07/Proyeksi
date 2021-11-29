#-- encoding: UTF-8


require 'bundler'
require 'json'

namespace :openproject do
  namespace :plugins do
    desc 'Register plugins from the :opf_plugins bundle group to the frontend'
    task register_frontend: [:environment] do
      ::OpenProject::Plugins::FrontendLinking.regenerate!
    end
  end
end
