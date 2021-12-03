module API
  module V3
    class UpdateQueryFromV3ParamsService
      def initialize(query, user)
        self.query = query
        self.current_user = user
      end

      def call(params, valid_subset: false)
        parsed = ::API::V3::ParseQueryParamsService
                   .new
                   .call(params)

        if parsed.success?
          ::UpdateQueryFromParamsService
            .new(query, current_user)
            .call(parsed.result, valid_subset: valid_subset)
        else
          parsed
        end
      end

      attr_accessor :query,
                    :current_user
    end
  end
end
