

# -- load spec_helper from ProyeksiApp core
require 'spec_helper'

require File.join(File.dirname(__FILE__), 'plugin_spec_helper')

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }
