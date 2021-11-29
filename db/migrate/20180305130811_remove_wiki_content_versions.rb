#-- encoding: UTF-8



class RemoveWikiContentVersions < ActiveRecord::Migration[5.1]
  def up
    drop_table :wiki_content_versions
  end

  def down
    create_table :wiki_content_versions, force: true do |t|
      t.integer :wiki_content_id, null: false
      t.integer :page_id, null: false
      t.integer :author_id
      t.binary :data, limit: 16.megabytes
      t.string :compression, limit: 6, default: ''
      t.string :comments, default: ''
      t.datetime :updated_on, null: false
      t.integer :version, null: false
    end

    add_index :wiki_content_versions, [:updated_on], name: 'index_wiki_content_versions_on_updated_on'
    add_index :wiki_content_versions, [:wiki_content_id], name: 'wiki_content_versions_wcid'
  end
end
