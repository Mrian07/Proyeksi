module API
  module V3
    module Capabilities
      class CapabilitySqlCollectionRepresenter < API::Decorators::SqlCollectionRepresenter
        self.embed_map = {
          elements: CapabilitySqlRepresenter
        }.with_indifferent_access
      end
    end
  end
end
