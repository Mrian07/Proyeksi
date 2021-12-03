

module ProyeksiApp::Bim::Patches::AttachmentPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def external_url_options(expires_in: nil)
      return super unless ifc_file?

      super.merge content_disposition: ifc_content_disposition
    end

    def content_disposition(include_filename: true)
      return super unless ifc_file? && include_filename
      
      ifc_content_disposition
    end

    def ifc_file?
      container_type == Bim::IfcModels::IfcModel.name && description == "ifc" && container.present?
    end

    def ifc_content_disposition
      "attachment; filename=#{ifc_file_name}"
    end

    def ifc_file_name
      title = container.title.sub /\.ifc\Z/, ''

      title.to_localized_slug(locale: :en) + ".ifc"
    end
  end
end
