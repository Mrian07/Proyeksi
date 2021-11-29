

module Bim::Bcf
  module Viewpoints
    class CreateService < ::BaseServices::Create
      protected

      def persist(service_result)
        # snapshot base64 data must not get stored
        service_result.result.json_viewpoint['snapshot']&.delete('snapshot_data')

        super(service_result)
      end
    end
  end
end
