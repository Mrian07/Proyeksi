#-- encoding: UTF-8



module API
  module V3
    module Utilities
      module EagerLoading
        class EagerLoadingWrapper < SimpleDelegator
          private_class_method :new

          ##
          # Workaround against warnings in flatten
          # delegator does not forward private method #to_ary
          def to_ary
            __getobj__.send(:to_ary)
          end

          class << self
            def wrap(objects)
              objects
                .map { |object| new(object) }
            end
          end
        end
      end
    end
  end
end
