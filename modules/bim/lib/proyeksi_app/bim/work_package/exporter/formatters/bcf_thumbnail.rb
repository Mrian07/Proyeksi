module ProyeksiApp::Bim::WorkPackage::Exporter::Formatters
  class BcfThumbnail < ::Exports::Formatters::Default
    def self.apply?(name)
      name.to_sym == :bcf_thumbnail
    end

    def format(work_package, **_options)
      work_package&.bcf_issue&.viewpoints&.any? ? "x" : ''
    end
  end
end
