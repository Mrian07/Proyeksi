#-- encoding: UTF-8



module API
  module V3
    module Queries
      class FormRepresenter < ::API::Decorators::Form
        link :self do
          {
            href: form_url,
            method: :post
          }
        end

        link :validate do
          {
            href: form_url,
            method: :post
          }
        end

        link :commit do
          if allow_commit?
            {
              href: resource_url,
              method: commit_method
            }
          end
        end

        link :create_new do
          if allow_create_as_new?
            {
              href: api_v3_paths.queries,
              method: :post
            }
          end
        end

        def commit_action
          raise NotImplementedError, "subclass responsibility"
        end

        def commit_method
          raise NotImplementedError, "subclass responsibility"
        end

        def form_url
          raise NotImplementedError, "subclass responsibility"
        end

        def resource_url
          raise NotImplementedError, "subclass responsibility"
        end

        def payload_representer
          QueryPayloadRepresenter
            .new(represented, current_user: current_user)
        end

        def schema_representer
          Schemas::QuerySchemaRepresenter.new(represented,
                                              form_embedded: true,
                                              current_user: current_user)
        end

        def allow_commit?
          @errors.empty? && represented.name.present? && allow_save?
        end

        def allow_save?
          QueryPolicy.new(current_user).allowed? represented, commit_action
        end

        def allow_create_as_new?
          QueryPolicy.new(current_user).allowed? represented, :create_new
        end
      end
    end
  end
end
