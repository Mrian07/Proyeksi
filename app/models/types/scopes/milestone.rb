#-- encoding: UTF-8



module Types::Scopes
  module Milestone
    extend ActiveSupport::Concern

    class_methods do
      def milestone
        where(is_milestone: true)
      end
    end
  end
end
