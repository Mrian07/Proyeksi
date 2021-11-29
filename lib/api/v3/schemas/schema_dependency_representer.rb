#-- encoding: UTF-8



module API
  module V3
    module Schemas
      class SchemaDependencyRepresenter < ::API::Decorators::Single
        property :on,
                 exec_context: :decorator

        property :dependencies,
                 exec_context: :decorator

        def initialize(dependencies, on, current_user:)
          self.on = on

          super(dependencies,
                current_user: current_user)
        end

        attr_accessor :on

        alias :dependencies :represented

        def _type
          'SchemaDependency'
        end
      end
    end
  end
end
