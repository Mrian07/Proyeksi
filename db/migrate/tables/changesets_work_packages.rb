#-- encoding: UTF-8

require_relative 'base'

class Tables::ChangesetsWorkPackages < Tables::Base
  def self.id_options
    { id: false }
  end

  def self.table(migration)
    create_table migration do |t|
      t.integer :changeset_id, null: false
      t.integer :work_package_id, null: false

      t.index %i[changeset_id work_package_id],
              unique: true,
              name: :changesets_work_packages_ids
    end
  end
end
