

require Rails.root.join("db", "migrate", "migration_utils", "migration_squasher").to_s
# This migration aggregates the migrations detailed in MIGRATION_FILES
class ToV710AggregatedDocumentsMigrations < ActiveRecord::Migration[5.1]
  MIGRATION_FILES = <<-MIGRATIONS
    20130807085604_create_document_journals.rb
    20130814131242_create_documents_tables.rb
    20140320140001_legacy_document_journal_data.rb
  MIGRATIONS

  def up
    Migration::MigrationSquasher.squash(migrations) do
      create_table "documents", id: :integer do |t|
        t.integer  "project_id", default: 0, null: false
        t.integer  "category_id", default: 0, null: false
        t.string   "title", limit: 60, default: "", null: false
        t.text     "description"
        t.datetime "created_on"
      end
      add_index "documents", ["category_id"], name: "index_documents_on_category_id"
      add_index "documents", ["created_on"], name: "index_documents_on_created_on"
      add_index "documents", ["project_id"], name: "documents_project_id"

      create_table :document_journals, id: :integer do |t|
        t.integer  :journal_id, null: false
        t.integer  :project_id, default: 0, null: false
        t.integer  :category_id, default: 0, null: false
        t.string   :title, limit: 60, default: "", null: false
        t.text     :description
        t.datetime :created_on
      end
    end
  end

  def down
    drop_table :documents
    drop_table :document_journals
  end

  private

  def migrations
    MIGRATION_FILES.split.map do |m|
      m.gsub(/_.*\z/, '')
    end
  end
end
