class MakeProjectIdentifierUnique < ActiveRecord::Migration[6.1]
  def change
    begin
      remove_index :projects, :identifier
    rescue => e
      raise <<~MESSAGE
        Failed to remove an index from the ProyeksiApp database: #{e.message}

        You likely have two ProyeksiApp database schemas running at the same time since migrating
        from MySQL to PostgreSQL.

        Please follow the following guide in our forums on how to correct this error before continuing the upgrade:
        https://community.proyeksiapp.org/topics/13672?r=13736#message-13736
      MESSAGE
    end

    begin
      add_index :projects, :identifier, unique: true
    rescue => e
      raise "You have a duplicate project identifier in your database: #{e.message}"
    end
  end
end
