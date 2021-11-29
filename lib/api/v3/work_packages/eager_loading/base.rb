#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      module EagerLoading
        class Base < SimpleDelegator
          def initialize(work_packages)
            self.work_packages = work_packages
          end

          def apply(_work_package)
            raise NotImplementedError
          end

          def self.module
            NoOp
          end

          protected

          attr_accessor :work_packages
        end

        module NoOp; end
      end
    end
  end
end
