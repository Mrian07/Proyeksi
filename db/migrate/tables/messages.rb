#-- encoding: UTF-8



require_relative 'base'

class Tables::Messages < Tables::Base
  # rubocop:disable Metrics/AbcSize
  def self.table(migration)
    create_table migration do |t|
      t.integer :board_id, null: false
      t.integer :parent_id
      t.string :subject, default: '', null: false
      t.text :content
      t.integer :author_id
      t.integer :replies_count, default: 0, null: false
      t.integer :last_reply_id
      t.datetime :created_on, null: false
      t.datetime :updated_on, null: false
      t.boolean :locked, default: false
      t.integer :sticky, default: 0
      t.datetime :sticked_on, default: nil, null: true

      t.index :author_id, name: 'index_messages_on_author_id'
      t.index :board_id, name: 'messages_board_id'
      t.index :created_on, name: 'index_messages_on_created_on'
      t.index :last_reply_id, name: 'index_messages_on_last_reply_id'
      t.index :parent_id, name: 'messages_parent_id'
      t.index %i[board_id updated_on]
    end
  end
  # rubocop:enable Metrics/AbcSize
end
