

module Bim
  module IfcModels
    class BaseContract < ::ModelContract
      delegate :project,
               :new_record?,
               to: :model

      attribute :title
      attribute :is_default
      attribute :project

      def self.model
        ::Bim::IfcModels::IfcModel
      end

      validate :user_allowed_to_manage
      validate :ifc_attachment_existent
      validate :ifc_attachment_is_ifc
      validate :uploader_is_ifc_attachment_author

      def user_allowed_to_manage
        if model.project && !user.allowed_to?(:manage_ifc_models, model.project)
          errors.add :base, :error_unauthorized
        end
      end

      def ifc_attachment_existent
        errors.add :base, :ifc_attachment_missing unless model.ifc_attachment
      end

      def ifc_attachment_is_ifc
        return unless model.ifc_attachment&.new_record? || model.ifc_attachment&.pending_direct_upload?

        file_path = model.ifc_attachment.file.local_file.path

        begin
          firstline = File.open(file_path, &:readline)

          unless firstline.match?(/^ISO-10303-21;/)
            errors.add :base, :invalid_ifc_file
          end
        rescue ArgumentError
          errors.add :base, :invalid_ifc_file
        ensure
          clean_up file_path
        end
      end

      def clean_up(file_path)
        # If we are using direct uploads we can safely discard the file here straight away
        # after we checked its contents. The actual file has already been uploaded to its final (remote) destination.
        # For local uploads the file must remain to be copied later to its final (local) destination from the cache.
        return unless ProyeksiApp::Configuration.direct_uploads?

        FileUtils.rm file_path if File.exists? file_path
      end

      def uploader_is_ifc_attachment_author
        errors.add :uploader_id, :invalid if model.ifc_attachment && model.uploader != model.ifc_attachment.author
      end
    end
  end
end
