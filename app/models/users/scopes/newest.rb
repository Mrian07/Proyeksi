#-- encoding: UTF-8



module Users::Scopes
  module Newest
    extend ActiveSupport::Concern

    class_methods do
      # Returns users sorted by their creation date. Inheriting classes are
      # excluded.
      def newest
        user.order(created_at: :desc)
      end
    end
  end
end
