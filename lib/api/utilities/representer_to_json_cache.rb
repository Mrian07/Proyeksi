#-- encoding: UTF-8

module API
  module Utilities
    module RepresenterToJsonCache
      def to_json(*)
        if json_cacheable?
          ProyeksiApp::Cache.fetch(*json_representer_name_cache_key, *json_cache_key) do
            super
          end
        else
          super
        end
      end

      def json_cacheable?
        true
      end

      def json_cache_key
        raise NotImplementedError
      end

      private

      def json_representer_name_cache_key
        self.class.name.to_s.split('::') + ['json', I18n.locale]
      end
    end
  end
end
