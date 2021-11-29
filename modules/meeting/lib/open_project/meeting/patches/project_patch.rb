

module OpenProject::Meeting
  module Patches
    module ProjectPatch
      def self.included(receiver)
        receiver.class_eval do
          has_many :meetings, -> { includes(:author) }, dependent: :destroy
        end
      end
    end
  end
end

Project.include OpenProject::Meeting::Patches::ProjectPatch
