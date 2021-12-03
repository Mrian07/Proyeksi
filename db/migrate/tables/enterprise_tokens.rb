require_relative 'base'

class Tables::EnterpriseTokens < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.text :encoded_token

      t.timestamps
    end
  end
end
