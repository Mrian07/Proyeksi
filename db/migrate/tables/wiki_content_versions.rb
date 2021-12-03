require_relative 'base'

class Tables::WikiContentVersions < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :wiki_content_id, null: false
      t.integer :page_id, null: false
      t.integer :author_id
      t.binary :data, limit: 16.megabytes
      t.string :compression, limit: 6, default: ''
      t.string :comments, default: ''
      t.datetime :updated_on, null: false
      t.integer :version, null: false

      t.index :updated_on, name: 'index_wiki_content_versions_on_updated_on'
      t.index :wiki_content_id, name: 'wiki_content_versions_wcid'
    end
  end
end
