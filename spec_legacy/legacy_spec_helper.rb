#-- encoding: UTF-8



ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)

require 'fileutils'
require 'rspec/mocks'
require 'factory_bot_rails'

require_relative './support/legacy_file_helpers'
require_relative './support/legacy_assertions'

require 'rspec/rails'
require 'shoulda/matchers'

# Required shared support helpers from spec/
Dir[Rails.root.join('spec/support/shared/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec, :minitest

  config.fixture_path = "#{::Rails.root}/spec_legacy/fixtures"

  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.include LegacyAssertionsAndHelpers
  config.include ActiveSupport::Testing::Assertions
  config.include Shoulda::Context::Assertions
  # included in order to use #fixture_file_upload
  config.include ActionDispatch::TestProcess

  config.include RSpec::Rails::RequestExampleGroup,   file_path: %r(spec_legacy/integration)
  config.include Shoulda::Matchers::ActionController, file_path: %r(spec_legacy/integration)
  config.extend Shoulda::Matchers::ActionController, file_path: %r(spec_legacy/integration)

  config.include(Module.new do
    extend ActiveSupport::Concern

    # FIXME: hack to ensure subject is an ActionDispatch::TestResponse (RSpec-port)
    included do
      subject { self }
    end
  end, file_path: %r(spec_legacy/integration))

  config.before(:suite) do |_example|
    Delayed::Worker.delay_jobs = false

    ProyeksiApp::Configuration['attachments_storage_path'] = 'tmp/files'
  end

  config.before(:each) do
    reset_global_state!

    initialize_attachments

    I18n.locale = 'en'
  end

  # colorized rspec output
  config.color = true
  config.formatter = 'progress'
end
