

module OpenProject
  module Cache
    module CacheKey
      def self.key(*parts)
        version_part = expand([OpenProject::VERSION, OpenProject::VERSION.product_version].compact)

        [version_part] + parts.flatten(1)
      end

      ##
      # Expand a cache key.
      # Shallow wrapper around ActiveSupport::Cache, which supports
      # anything that responds to #cache_key or #to_param, or strings
      def self.expand(cachable)
        key = ActiveSupport::Cache.expand_cache_key cachable

        Digest::SHA2.hexdigest(key)
      end
    end
  end
end
