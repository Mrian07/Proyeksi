

require Rails.root.join("db", "migrate", "migration_utils", "migration_squasher").to_s
# This migration aggregates the migrations detailed in MIGRATION_FILES
class ToV710AggregatedReportingMigrations < ActiveRecord::Migration[5.1]
  MIGRATION_FILES = <<-MIGRATIONS
    20110215143061_aggregated_reporting_migrations.rb
    20130612104243_reporting_migrate_serialized_yaml.rb
    20130925090243_cost_reports_migration.rb
  MIGRATIONS

  def up
    Migration::MigrationSquasher.squash(migrations) do
      create_table "cost_queries", id: :integer do |t|
        t.integer  "user_id", null: false
        t.integer  "project_id"
        t.string   "name", null: false
        t.boolean  "is_public", default: false, null: false
        t.datetime "created_on",                                    null: false
        t.datetime "updated_on",                                    null: false
        t.string   "serialized", limit: 2000, null: false
      end
    end
  end

  def down
    drop_table "cost_queries"
  end

  private

  def migrations
    MIGRATION_FILES.split.map do |m|
      m.gsub(/_.*\z/, '')
    end
  end
end
