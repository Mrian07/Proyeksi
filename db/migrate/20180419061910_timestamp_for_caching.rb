

class TimestampForCaching < ActiveRecord::Migration[5.1]
  def change
    [Enumeration, Status, Category, AuthSource].each do |model|
      add_timestamps(model)
    end
  end

  def add_timestamps(model)
    table = model.table_name

    change_table table do |t|
      t.timestamps null: true
    end

    model.update_all(updated_at: Time.now, created_at: Time.now)

    change_column_null table, :created_at, false
    change_column_null table, :updated_at, false
  end
end
