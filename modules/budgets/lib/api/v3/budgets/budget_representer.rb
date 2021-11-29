

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Budgets
      class BudgetRepresenter < ::API::Decorators::Single
        self_link title_getter: ->(*) { represented.subject }
        include API::Caching::CachedRepresenter
        include ::API::V3::Attachments::AttachableRepresenterMixin

        link :staticPath do
          next if represented.new_record?

          {
            href: budget_path(represented.id)
          }
        end

        property :id, render_nil: true
        property :subject, render_nil: true

        def _type
          'Budget'
        end
      end
    end
  end
end
