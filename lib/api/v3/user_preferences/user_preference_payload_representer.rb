#-- encoding: UTF-8

module API
  module V3
    module UserPreferences
      class UserPreferencePayloadRepresenter < UserPreferenceRepresenter
        include ::API::Utilities::PayloadRepresenter
      end
    end
  end
end
