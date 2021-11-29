#-- encoding: UTF-8



module API
  module V3
    module Queries
      module Schemas
        class FilterDependencyRepresenter < ::API::Decorators::SchemaRepresenter
          include API::Utilities::RepresenterToJsonCache

          def initialize(filter, operator, form_embedded: false)
            self.operator = operator

            super(filter, current_user: nil, form_embedded: form_embedded)
          end

          schema_with_allowed_link :values,
                                   type: ->(*) { type },
                                   writable: true,
                                   has_default: false,
                                   required: true,
                                   href_callback: ->(*) {
                                     href_callback
                                   },
                                   show_if: ->(*) {
                                     value_required?
                                   }

          property :_dependencies,
                   if: false,
                   exec_context: :decorator

          def _type; end

          # While this is not actually the represented class,
          # this is what the superclass expects in order to have the
          # right i18n
          def self.represented_class
            Query
          end

          # Avoid having a _links section on the json objects
          def to_hash(*)
            super.tap do |hash|
              hash.delete('_links')
            end
          end

          def json_cache_key
            [operator.to_sym, I18n.locale, form_embedded]
          end

          private

          def value_required?
            operator.requires_value?
          end

          def type
            raise NotImplementedError, 'Subclass has to implement #type'
          end

          def href_callback
            raise NotImplementedError, 'Subclass has to implement #href_callback'
          end

          attr_accessor :operator

          alias :filter :represented
        end
      end
    end
  end
end
