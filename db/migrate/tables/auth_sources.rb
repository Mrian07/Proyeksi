#-- encoding: UTF-8



require_relative 'base'

class Tables::AuthSources < Tables::Base
  def self.table(migration)
    create_table migration do |t|
      t.string :type, limit: 30, default: '', null: false
      t.string :name, limit: 60, default: '', null: false
      t.string :host, limit: 60
      t.integer :port
      t.string :account
      t.string :account_password, default: ''
      t.string :base_dn
      t.string :attr_login, limit: 30
      t.string :attr_firstname, limit: 30
      t.string :attr_lastname, limit: 30
      t.string :attr_mail, limit: 30
      t.boolean :onthefly_register, default: false, null: false
      t.boolean :tls, default: false, null: false
      t.string :attr_admin

      t.index %i[id type], name: 'index_auth_sources_on_id_and_type'
    end
  end
end
