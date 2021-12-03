#-- encoding: UTF-8

module API
  module V3
    module WorkPackages
      module EagerLoading
        class NeutralWrapper < SimpleDelegator
          private_class_method :new

          def wrapped?
            true
          end

          class << self
            def wrap_one(work_package, _current_user)
              new(work_package)
            end

            def name
              "WorkPackage"
            end
          end
        end
      end
    end
  end
end
