

require 'spec_helper'

describe 'ProyeksiApp::Configuration' do
  context '.cost_reporting_cache_filter_classes' do
    before do
      # This prevents the values from the actual configuration file to influence
      # the test outcome.
      #
      # TODO: I propose to port this over to the core to always prevent this for specs.
      ProyeksiApp::Configuration.load(file: 'bogus')
    end

    after do
      # resetting for now to avoid braking specs, who by now rely on having the file read.
      ProyeksiApp::Configuration.load
    end

    it 'is a true by default via the method' do
      expect(ProyeksiApp::Configuration.cost_reporting_cache_filter_classes).to be_truthy
    end

    it 'is true by default via the hash' do
      expect(ProyeksiApp::Configuration['cost_reporting_cache_filter_classes']).to be_truthy
    end
  end
end
