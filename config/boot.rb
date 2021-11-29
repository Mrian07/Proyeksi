#-- encoding: UTF-8



ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Load any local boot extras that is kept out of source control
# (e.g., silencing of deprecations)
if File.exists?(File.join(File.dirname(__FILE__), 'additional_boot.rb'))
  instance_eval File.read(File.join(File.dirname(__FILE__), 'additional_boot.rb'))
end

require 'bundler/setup' # Set up gems listed in the Gemfile.

env = ENV['RAILS_ENV']
# Disable deprecation warnings early on (before loading gems), which behaves as RUBYOPT="-w0"
# to disable the Ruby 2.7 warnings in production.
# Set OPENPROJECT_PROD_DEPRECATIONS=true if you want to see them for debugging purposes
if env == 'production' && ENV['OPENPROJECT_PROD_DEPRECATIONS'] != 'true'
  require 'structured_warnings'
  Warning[:deprecated] = false
  StructuredWarnings::BuiltInWarning.disable
  StructuredWarnings::DeprecationWarning.disable
end

if env == 'development'
  warn "Starting with bootsnap."
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end
