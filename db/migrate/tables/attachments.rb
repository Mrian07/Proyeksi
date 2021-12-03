#-- encoding: UTF-8

require_relative 'base'

class Tables::Attachments < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :container_id, default: 0, null: false
      t.string :container_type, limit: 30, default: '', null: false
      t.string :filename, default: '', null: false
      t.string :disk_filename, default: '', null: false
      t.integer :filesize, default: 0, null: false
      t.string :content_type, default: ''
      t.string :digest, limit: 40, default: '', null: false
      t.integer :downloads, default: 0, null: false
      t.integer :author_id, default: 0, null: false
      t.datetime :created_on
      t.string :description
      t.string :file

      t.index :author_id, name: 'index_attachments_on_author_id'
      t.index %i[container_id container_type], name: 'index_attachments_on_container_id_and_container_type'
      t.index :created_on, name: 'index_attachments_on_created_on'
    end
  end
end
