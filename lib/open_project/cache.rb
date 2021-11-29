

require_relative 'cache/cache_key'

module OpenProject
  module Cache
    def self.fetch(*parts, &block)
      Rails.cache.fetch(CacheKey.key(*parts), &block)
    end

    def self.clear
      Rails.cache.clear
    end
  end
end
