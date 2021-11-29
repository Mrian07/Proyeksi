

require_relative 'base'

class Tables::WikiPages < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :wiki_id, null: false
      t.string :title, null: false
      t.datetime :created_on, null: false
      t.boolean :protected, default: false, null: false
      t.integer :parent_id
      t.string :slug, null: false

      t.index %i[wiki_id slug], name: 'wiki_pages_wiki_id_slug', unique: true
      t.index :parent_id, name: 'index_wiki_pages_on_parent_id'
      t.index %i[wiki_id title], name: 'wiki_pages_wiki_id_title'
      t.index :wiki_id, name: 'index_wiki_pages_on_wiki_id'
    end
  end
end
