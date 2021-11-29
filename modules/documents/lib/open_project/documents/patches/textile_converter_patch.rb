

module OpenProject::Documents::Patches
  module TextileConverterPatch
    def models_to_convert
      super.merge(::Document => [:description])
    end
  end
end

::OpenProject::TextFormatting::Formats::Markdown::TextileConverter.prepend(
  ::OpenProject::Documents::Patches::TextileConverterPatch
)
