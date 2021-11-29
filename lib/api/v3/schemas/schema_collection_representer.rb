#-- encoding: UTF-8



module API
  module V3
    module Schemas
      class SchemaCollectionRepresenter <
        ::API::Decorators::UnpaginatedCollection
        def initialize(represented, self_link:, current_user:, form_embedded: false)
          self.form_embedded = form_embedded

          super(represented, self_link: self_link, current_user: current_user)
        end

        collection :elements,
                   getter: ->(*) {
                     represented.map do |model|
                       self_link = model_self_link(model)

                       element_decorator.create(model,
                                                self_link: self_link,
                                                current_user: current_user,
                                                form_embedded: form_embedded)
                     end
                   },
                   exec_context: :decorator,
                   embedded: true

        private

        attr_accessor :form_embedded

        def model_self_link(_model)
          raise NotImplementedError, 'Subclass has to implement this'
        end
      end
    end
  end
end
