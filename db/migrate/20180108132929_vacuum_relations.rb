class VacuumRelations < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def up
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      connection.execute 'vacuum relations'
    end
  end
end
