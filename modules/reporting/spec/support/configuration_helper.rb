

module ProyeksiApp::Reporting::SpecHelper
  module ConfigurationHelper
    def mock_cache_classes_setting_with(value)
      allow(ProyeksiApp::Configuration).to receive(:[]).and_call_original
      allow(ProyeksiApp::Configuration).to receive(:[])
        .with('cost_reporting_cache_filter_classes')
        .and_return(value)
      allow(ProyeksiApp::Configuration).to receive(:cost_reporting_cache_filter_classes)
        .and_return(value)
    end
  end
end
