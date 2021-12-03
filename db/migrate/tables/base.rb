#-- encoding: UTF-8

module Tables
  ;
end

class Tables::Base
  def self.create(migration)
    table(migration)
  end

  def self.table_name
    name.demodulize.underscore.to_s
  end

  def self.id_options
    { id: :integer }
  end

  def self.create_table(migration, &block)
    migration.create_table table_name, **id_options.merge(bulk: true), &block
  end

  def self.table(_migration)
    raise NotImplementedError
  end
end
