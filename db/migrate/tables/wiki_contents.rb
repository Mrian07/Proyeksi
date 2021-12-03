require_relative 'base'

class Tables::WikiContents < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :page_id, null: false
      t.integer :author_id
      t.text :text, limit: 16.megabytes
      t.datetime :updated_on, null: false
      t.integer :lock_version, null: false

      t.index :author_id, name: 'index_wiki_contents_on_author_id'
      t.index :page_id, name: 'wiki_contents_page_id'
      t.index %i[page_id updated_on]
    end
  end
end
