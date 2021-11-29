#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        module CustomFieldJsonCacheKeyMixin
          def self.extended(base)
            base.instance_eval do
              alias :orig_json_cache_key :json_cache_key

              def json_cache_key
                orig_json_cache_key + [filter.custom_field.cache_key]
              end
            end
          end
        end
      end
    end
  end
end
