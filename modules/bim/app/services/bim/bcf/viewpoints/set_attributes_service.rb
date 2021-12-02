

module Bim::Bcf
  module Viewpoints
    class SetAttributesService < ::BaseServices::SetAttributes
      private

      def set_attributes(params)
        super

        set_snapshot
      end

      def set_default_attributes(_params)
        viewpoint['guid'] = model.uuid
      end

      def set_snapshot
        return unless snapshot_data_complete? && snapshot_content_type

        name = "snapshot.#{snapshot_extension}"
        file = ProyeksiApp::Files
                 .create_uploaded_file(name: name,
                                       content_type: snapshot_content_type,
                                       content: snapshot_binary_contents,
                                       binary: true)

        # This might break once the service is also used
        # to update existing viewpoints as the snapshot method will
        # delete any existing snapshot right away while the expectation
        # on a SetAttributesService is to not perform persisted changes.
        model.snapshot&.mark_for_destruction
        model.build_snapshot file, user: user
      end

      def snapshot_data_complete?
        viewpoint['snapshot'] &&
          snapshot_extension &&
          snapshot_base64 &&
          snapshot_url_parts.length > 1
      end

      def snapshot_content_type
        # Return nil when the extension is not within the specified set
        # which will lead to the snapshot not being created.
        # The contract will catch the error.
        return unless viewpoint['snapshot']

        case viewpoint['snapshot']['snapshot_type']
        when 'png'
          'image/png'
        when 'jpg'
          'image/jpeg'
        end
      end

      def snapshot_extension
        viewpoint['snapshot']['snapshot_type']
      end

      def snapshot_base64
        viewpoint['snapshot']['snapshot_data']
      end

      def snapshot_binary_contents
        Base64.decode64(snapshot_url_parts[2])
      end

      def snapshot_url_parts
        snapshot_base64.match(/\Adata:([-\w]+\/[-\w+.]+)?;base64,(.*)/m) || []
      end

      def viewpoint
        model.json_viewpoint
      end
    end
  end
end
