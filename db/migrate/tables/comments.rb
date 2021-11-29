#-- encoding: UTF-8



require_relative 'base'

class Tables::Comments < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :commented_type, limit: 30, default: '', null: false
      t.integer :commented_id, default: 0, null: false
      t.integer :author_id, default: 0, null: false
      t.text :comments
      t.datetime :created_on, null: false
      t.datetime :updated_on, null: false

      t.index :author_id, name: 'index_comments_on_author_id'
      t.index %i[commented_id commented_type], name: 'index_comments_on_commented_id_and_commented_type'
    end
  end
end
