#-- encoding: UTF-8

# The conversion of MySQL databases to PostgreSQL seems to create a lot of columns
# that should be of type `integer` but are created as `bigint`.
# This leads to cast errors e.g. when combining an array of integers with a bigint.
# This migration only focuses on two columns in the relations table
# as they need to be integers for custom sql (scope WorkPackages.for_scheduling).
class EnsureIntegerForRelationsForeignKeys < ActiveRecord::Migration[6.0]
  def up
    # The table information we have might be outdated
    Relation.reset_column_information

    # Nothing to do for us if the column already has the expected type
    return if Relation.column_for_attribute('from_id').sql_type == 'integer'

    change_table :relations do |t|
      t.change :from_id, :integer, null: false
      t.change :to_id, :integer, null: false
    end

    Relation.reset_column_information
  end
end
