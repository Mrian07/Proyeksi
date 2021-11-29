

require_relative 'base'

class Tables::Repositories < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id, default: 0, null: false
      t.string :url, default: '', null: false
      t.string :login, limit: 60, default: ''
      t.string :password, default: ''
      t.string :root_url, default: ''
      t.string :type
      t.string :path_encoding, limit: 64
      t.string :log_encoding, limit: 64
      t.string :scm_type, null: false
      t.integer :required_storage_bytes, limit: 8, null: false, default: 0
      t.datetime :storage_updated_at

      t.index :project_id, name: 'index_repositories_on_project_id'
    end
  end
end
