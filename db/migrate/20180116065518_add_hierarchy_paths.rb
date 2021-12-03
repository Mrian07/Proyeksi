#-- encoding: UTF-8

class AddHierarchyPaths < ActiveRecord::Migration[5.1]
  def change
    create_table :hierarchy_paths, id: :integer do |t|
      t.belongs_to :work_package, index: { unique: true }
      # (255 * 3) = ca 767 bytes is the max length for an index in mysql 5.6 InnoDB
      t.string :path, null: false, limit: 255

      t.index :path
    end
  end
end
