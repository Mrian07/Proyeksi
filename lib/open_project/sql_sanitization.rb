#-- encoding: UTF-8



module OpenProject
  ##
  # Provides helpers from ActiveRecord::Sanitization
  # outside model context
  module SqlSanitization
    include ::ActiveRecord::Sanitization

    def self.connection
      ::ActiveRecord::Base.connection
    end

    ##
    # Shorthand for:
    # sanitize_sql_array [str, :param0, param1]
    # sanitize_sql_array [str, param0: foo, param1: bar]
    def self.sanitize(sql, *args)
      sanitize_sql_array [sql, *args]
    end
  end
end
