#-- encoding: UTF-8



module OpenProject
  module Journal
    module AttachmentHelper
      def attachments_changed(_obj)
        unless new_record?
          add_journal
          save
        end
      end
    end
  end
end
