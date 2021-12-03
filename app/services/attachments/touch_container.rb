#-- encoding: UTF-8

module Attachments
  module TouchContainer
    extend ActiveSupport::Concern

    included do
      private

      def touch(container)
        # We allow invalid containers to be saved as
        # adding the attachments does not change the validity of the container
        # but without that leeway, the user needs to fix the container before
        # the attachment can be added.
        # However we want the container to be updated when uploading an attachment. This is important,
        # e.g. for invalidating caches and also for journalizing
        container.update_column(:updated_at, Time.current)
        container.save_journals if container.respond_to?(:save_journals)
      end
    end
  end
end
