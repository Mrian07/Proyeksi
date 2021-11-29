

module API
  module V3
    module Actions
      class ActionSqlCollectionRepresenter < API::Decorators::SqlCollectionRepresenter
        self.embed_map = {
          elements: ActionSqlRepresenter
        }.with_indifferent_access
      end
    end
  end
end
