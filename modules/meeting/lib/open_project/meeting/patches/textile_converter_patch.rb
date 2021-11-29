#-- encoding: UTF-8



module OpenProject::Meeting::Patches
  module TextileConverterPatch
    extend ActiveSupport::Concern

    included do
      prepend(Patch)
    end

    module Patch
      def models_to_convert
        super.merge(
          ::MeetingContent => [:text],
          ::Journal::MeetingContentJournal => [:text]
        )
      end
    end
  end
end
