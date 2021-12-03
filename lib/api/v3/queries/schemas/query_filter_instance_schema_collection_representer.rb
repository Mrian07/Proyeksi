#-- encoding: UTF-8

module API
  module V3
    module Queries
      module Schemas
        class QueryFilterInstanceSchemaCollectionRepresenter <
          ::API::V3::Schemas::SchemaCollectionRepresenter

          def model_self_link(model)
            converted_name = API::Utilities::PropertyNameConverter.from_ar_name(model.name)

            api_v3_paths.query_filter_instance_schema(converted_name)
          end
        end
      end
    end
  end
end
