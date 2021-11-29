#-- encoding: UTF-8



require_relative 'base'

class Tables::Changes < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :changeset_id, null: false
      t.string :action, limit: 1, default: '', null: false
      t.text :path, null: false
      t.text :from_path
      t.string :from_revision
      t.string :revision
      t.string :branch

      t.index :changeset_id, name: 'changesets_changeset_id'
    end
  end
end
