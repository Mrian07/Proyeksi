

module ProyeksiApp::Documents::Patches
  module TextileConverterPatch
    def models_to_convert
      super.merge(::Document => [:description])
    end
  end
end

::ProyeksiApp::TextFormatting::Formats::Markdown::TextileConverter.prepend(
  ::ProyeksiApp::Documents::Patches::TextileConverterPatch
)
