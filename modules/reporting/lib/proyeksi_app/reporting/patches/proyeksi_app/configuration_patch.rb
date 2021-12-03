

require_dependency 'proyeksi_app/configuration'

module ProyeksiApp::Reporting::Patches
  module ProyeksiApp::ConfigurationPatch
    def self.included(base)
      base.class_eval do
        extend ModuleMethods

        @defaults['cost_reporting_cache_filter_classes'] = true

        if config_loaded_before_patch?
          @config['cost_reporting_cache_filter_classes'] = true
        end
      end
    end

    module ModuleMethods
      def config_loaded_before_patch?
        @config.present? && !@config.has_key?('cost_reporting_cache_filter_classes')
      end

      def cost_reporting_cache_filter_classes
        @config['cost_reporting_cache_filter_classes']
      end
    end
  end
end
