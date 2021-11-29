

module Bim::Bcf
  module API
    module V2_1
      class ParseResourceParamsService < ::API::ParseResourceParamsService
        private

        def deduce_representer(model)
          "Bcf::API::V2_1::#{model.to_s.pluralize}::SingleRepresenter".constantize
        end

        def parsing_representer
          representer
            .new(struct)
        end
      end
    end
  end
end
