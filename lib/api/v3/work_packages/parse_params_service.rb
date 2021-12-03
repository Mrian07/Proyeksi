module API
  module V3
    module WorkPackages
      class ParseParamsService < API::V3::ParseResourceParamsService
        # Be compatible to super
        def initialize(user, **_args)
          super(user, model: WorkPackage, representer: ::API::V3::WorkPackages::WorkPackagePayloadRepresenter)
        end

        private

        def parse_attributes(request_body)
          ::API::V3::WorkPackages::WorkPackagePayloadRepresenter
            .create_class(struct, current_user)
            .new(struct, current_user: current_user)
            .from_hash(Hash(request_body))
            .to_h
            .reverse_merge(lock_version: nil)
        end

        def struct
          ParsingStruct.new
        end

        class ParsingStruct < OpenStruct
          def available_custom_fields
            @available_custom_fields ||= WorkPackageCustomField.all.to_a
          end
        end
      end
    end
  end
end
