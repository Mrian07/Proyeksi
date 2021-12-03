#-- encoding: UTF-8

require_relative 'base'

class Tables::Boards < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, null: false
      t.string :name, default: '', null: false
      t.string :description
      t.integer :position, default: 1
      t.integer :topics_count, default: 0, null: false
      t.integer :messages_count, default: 0, null: false
      t.integer :last_message_id

      t.index :last_message_id, name: "index_#{table_name}_on_last_message_id"
      t.index :project_id, name: "#{table_name}_project_id"
    end
  end
end
