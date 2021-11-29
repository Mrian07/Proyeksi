

# -- load spec_helper from OpenProject core
require 'spec_helper'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
