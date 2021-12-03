#-- encoding: UTF-8

class RemoveNonNullContainerOnAttachments < ActiveRecord::Migration[5.1]
  def change
    change_column_null :attachments, :container_id, true
    change_column_null :attachments, :container_type, true

    change_column_default :attachments, :container_id, from: 0, to: nil
    change_column_default :attachments, :container_type, from: '', to: nil

    change_column_null :attachment_journals, :container_id, true
    change_column_null :attachment_journals, :container_type, true

    change_column_default :attachment_journals, :container_id, from: 0, to: nil
    change_column_default :attachment_journals, :container_type, from: '', to: nil

    add_column :attachments, :updated_at, :datetime
    rename_column :attachments, :created_on, :created_at

    reversible do |change|
      change.up { Attachment.update_all("updated_at = created_at") }
    end
  end
end
