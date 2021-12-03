

module ProyeksiApp::Meeting
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

Project.include ProyeksiApp::Meeting::Patches::ProjectPatch
