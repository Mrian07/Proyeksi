#-- encoding: UTF-8



# puffing-billy is a gem that creates a middleman proxy between the browser controlled
# by capybara/selenium and the spec execution.
#
# This allows us to stub requests to external APIs to guarantee responses regardless of
# their availability.
#
# In order to use the proxied server, you need to use `driver: firefox_billy` in your examples
#
# See https://github.com/oesmith/puffing-billy for more information
require 'billy/capybara/rspec'

require 'table_print' # Add this dependency to your gemfile

##
# Patch `puffing-billy`'s proxy so that it doesn't try to stop
# eventmachine's reactor if it's not running.
# https://github.com/oesmith/puffing-billy/issues/253
module BillyProxyPatch
  def stop
    return unless EM.reactor_running?
  rescue Errno::ECONNRESET => e
    warn "Got error while shutting down Billy proxy"
  end
end

::Billy::Proxy.prepend(BillyProxyPatch)

##
# To debug stubbed and proxied connections
# uncomment this line
#
# Billy.configure do |c|
#   c.record_requests = true
# end
#
# RSpec.configure do |config|
#   config.prepend_after(:example, type: :feature) do
#     puts "Requests received via Puffing Billy Proxy:"
#
#     puts TablePrint::Printer.table_print(Billy.proxy.requests, [
#       :status,
#       :handler,
#       :method,
#       { url: { width: 100 } },
#       :headers,
#       :body
#     ])
#   end
# end
