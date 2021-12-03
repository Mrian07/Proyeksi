#-- encoding: UTF-8

# Return mail notifications destined at the provided recipient
module Notifications::Scopes
  module Recipient
    extend ActiveSupport::Concern

    class_methods do
      def recipient(user)
        where(recipient_id: user.is_a?(User) ? user.id : user)
      end
    end
  end
end
