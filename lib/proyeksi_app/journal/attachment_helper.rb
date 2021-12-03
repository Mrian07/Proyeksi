#-- encoding: UTF-8



module ProyeksiApp
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
