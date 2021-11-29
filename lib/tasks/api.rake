

namespace :api do
  desc 'Print all api routes'
  task routes: [:environment] do
    puts <<~HEADER

      Method     Route

    HEADER

    API::Root
      .routes
      .sort_by { |route| route.path + route.request_method }
      .each do |api|
      method = api.request_method.ljust(10)
      path = api.path.gsub(/\A\/:version/, "/api/v3").gsub(/\(\/?\.:format\)/, '')

      puts "#{method} #{path}"
    end
  end
end
