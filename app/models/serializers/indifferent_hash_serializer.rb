#-- encoding: UTF-8


module Serializers
  class IndifferentHashSerializer
    def self.dump(hash)
      hash
    end

    def self.load(value)
      hash = value.is_a?(Hash) ? value : {}
      hash.with_indifferent_access
    end
  end
end
