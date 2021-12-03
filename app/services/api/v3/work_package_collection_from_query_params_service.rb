module API
  module V3
    class WorkPackageCollectionFromQueryParamsService
      def initialize(user, scope: nil)
        self.current_user = user
        self.scope = scope
      end

      def call(params = {})
        query = Query.new_default(name: '_', project: params[:project])

        WorkPackageCollectionFromQueryService
          .new(query, current_user, scope: scope)
          .call(params)
      end

      private

      attr_accessor :current_user,
                    :scope
    end
  end
end
