#-- encoding: UTF-8

module Migration
  module Utils
    UpdateResult = Struct.new(:row, :updated)

    def say_with_time_silently(message, &block)
      say_with_time message do
        suppress_messages(&block)
      end
    end

    def in_configurable_batches(klass, default_batch_size: 1000)
      batches = ENV["PROYEKSIAPP_MIGRATION_BATCH_SIZE"]&.to_i || default_batch_size

      klass.in_batches(of: batches)
    end

    def remove_index_if_exists(table_name, index_name)
      if index_name_exists? table_name, index_name
        remove_index table_name, name: index_name
      end
    end
  end
end
