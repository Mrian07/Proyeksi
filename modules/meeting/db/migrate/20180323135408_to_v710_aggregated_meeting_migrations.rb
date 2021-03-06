

require Rails.root.join("db", "migrate", "migration_utils", "migration_squasher").to_s
# This migration aggregates the migrations detailed in MIGRATION_FILES
class ToV710AggregatedMeetingMigrations < ActiveRecord::Migration[5.1]
  MIGRATION_FILES = <<-MIGRATIONS
    20111605171865_aggregated_meeting_migrations.rb
    20130924114042_legacy_meeting_minutes_journal_data.rb
    20130731151542_remove_meeting_role_id_from_meeting_participants.rb
    20131127120534_migrate_text_references_to_work_packages.rb
    20130822113942_create_meeting_journals.rb
    20160504064737_add_index_for_latest_meeting_activity.rb
    20130924091342_legacy_meeting_journal_data.rb
    20130924093842_legacy_meeting_agenda_journal_data.rb
  MIGRATIONS

  def up
    Migration::MigrationSquasher.squash(migrations) do
      create_table 'meeting_contents', id: :integer do |t|
        t.string 'type'
        t.integer 'meeting_id'
        t.integer 'author_id'
        t.text 'text'
        t.integer 'lock_version'
        t.datetime 'created_at',                      null: false
        t.datetime 'updated_at',                      null: false
        t.boolean 'locked', default: false
      end

      create_table 'meeting_participants', id: :integer do |t|
        t.integer 'user_id'
        t.integer 'meeting_id'
        t.string 'email'
        t.string 'name'
        t.boolean 'invited'
        t.boolean 'attended'
        t.datetime 'created_at',      null: false
        t.datetime 'updated_at',      null: false
      end

      create_table 'meetings', id: :integer do |t|
        t.string 'title'
        t.integer 'author_id'
        t.integer 'project_id'
        t.string 'location'
        t.datetime 'start_time'
        t.float 'duration'
        t.datetime 'created_at', null: false
        t.datetime 'updated_at', null: false

        t.index %i[project_id updated_at]
      end

      create_table :meeting_journals, id: :integer do |t|
        t.integer :journal_id, null: false
        t.string :title
        t.integer :author_id
        t.integer :project_id
        t.string :location
        t.datetime :start_time
        t.float :duration
      end

      create_table :meeting_content_journals, id: :integer do |t|
        t.integer :journal_id, null: false
        t.integer :meeting_id
        t.integer :author_id
        t.text :text
        t.boolean :locked
      end
    end
  end

  def down
    drop_table 'meeting_contents'
    drop_table 'meeting_participants'
    drop_table 'meetings'
    drop_table :meeting_journals
    drop_table :meeting_content_journals
  end

  private

  def migrations
    MIGRATION_FILES.split.map do |m|
      m.gsub(/_.*\z/, '')
    end
  end
end
