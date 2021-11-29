#-- encoding: UTF-8



module Aggregated; end

class Aggregated::Base
  def self.migrations
    raise NotImplementedError
  end

  def self.normalized_migrations
    migrations.split.map do |m|
      m.gsub(/_.*\z/, '').to_i
    end
  end
end
