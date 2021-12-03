require_relative 'base'

class Tables::News < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.integer :project_id
      t.string :title, limit: 60, default: '', null: false
      t.string :summary, default: ''
      t.text :description
      t.integer :author_id, default: 0, null: false
      t.datetime :created_on
      t.integer :comments_count, default: 0, null: false

      t.index :author_id, name: 'index_news_on_author_id'
      t.index :created_on, name: 'index_news_on_created_on'
      t.index :project_id, name: 'news_project_id'
      t.index %i[project_id created_on]
    end
  end
end
