#-- encoding: UTF-8

class TzinfoTimeZones < ActiveRecord::Migration[6.1]
  def up
    zone_mappings = ActiveSupport::TimeZone
                      .all
                      .map do |tz|
      [
        [tz.name, tz.tzinfo.canonical_zone.name],
        # Some entries seem to already be in that format so we leave them unchanged
        [tz.tzinfo.canonical_zone.name, tz.tzinfo.canonical_zone.name]
      ]
    end
                      .flatten(1)

    migrate_user_time_zone(zone_mappings)
    migrate_default_time_zone(zone_mappings)
  end

  def down
    zone_mappings = ActiveSupport::TimeZone
                      .all
                      .map do |tz|
      [tz.tzinfo.canonical_zone.name, tz.name]
    end

    migrate_user_time_zone(zone_mappings)
    migrate_default_time_zone(zone_mappings)
  end

  protected

  def migrate_user_time_zone(mappings)
    execute <<~SQL.squish
      WITH source AS (
        SELECT id, settings || jsonb_build_object('time_zone', to_zone) settings
        FROM user_preferences
        LEFT JOIN (SELECT * FROM (#{Arel::Nodes::ValuesList.new(mappings).to_sql}) as t(from_zone, to_zone)) zones
          ON zones.from_zone = user_preferences.settings->>'time_zone'
      )

      UPDATE user_preferences sink
      SET settings = source.settings
      FROM source
      WHERE source.id = sink.id
      AND sink.settings->'time_zone' IS NOT NULL
    SQL
  end

  def migrate_default_time_zone(mappings)
    execute <<~SQL.squish
      WITH zones AS (
        SELECT * FROM (#{Arel::Nodes::ValuesList.new(mappings).to_sql}) as t(from_zone, to_zone)
      )

      UPDATE settings
      SET value = zones.to_zone
      FROM zones
      WHERE settings.name = 'user_default_timezone'
      AND settings.value = zones.from_zone
    SQL
  end
end
