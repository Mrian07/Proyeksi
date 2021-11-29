#-- encoding: UTF-8



module API
  module Decorators
    module PolymorphicResource
      # Dynamically derive a linked resource from the given polymorphic resource
      def polymorphic_resource(name,
                               as: nil,
                               skip_render: ->(*) { false },
                               skip_link: skip_render,
                               uncacheable_link: false,
                               link_title_attribute: :name)

        resource((as || name),
                 getter: polymorphic_resource_getter(name),
                 setter: polymorphic_resource_setter(as),
                 link: polymorphic_link(name, link_title_attribute, skip_link),
                 uncacheable_link: uncacheable_link,
                 skip_render: skip_render)
      end

      private

      def polymorphic_resource_getter(name)
        representer_fn = method(:polymorphic_resource_representer)
        ->(*) do
          next unless embed_links

          resource = represented.send(name)
          next if resource.nil?

          representer = representer_fn.call(resource)
          representer.create(resource, current_user: current_user)
        end
      end

      def polymorphic_resource_setter(as)
        ->(fragment:, **) do
          name = represented.model_name.singular
          link = ::API::Decorators::LinkObject.new(represented,
                                                   path: name,
                                                   property_name: as || name,
                                                   getter: :"#{name}_id",
                                                   setter: :"#{name}_id=")

          link.from_hash(fragment)
        end
      end

      def polymorphic_link(name, title_attribute, skip_link)
        path_fn = method(:polymorphic_resource_path)

        ->(*) do
          next if instance_exec(&skip_link)

          resource = represented.send(name)
          next if resource.nil?

          path_name = path_fn.call(resource)

          ::API::Decorators::LinkObject
            .new(represented,
                 path: path_name,
                 property_name: name,
                 title_attribute: title_attribute,
                 getter: :"#{name}_id")
            .to_hash
        end
      end

      def polymorphic_resource_representer(resource)
        mapped_representer(resource) || polymorphic_default_representer(resource.model_name)
      end

      def mapped_representer(resource)
        case resource
        when Journal
          ::API::V3::Activities::ActivityRepresenter
        end
      end

      def polymorphic_resource_path(resource)
        case resource
        when Journal
          :activity
        else
          resource.model_name.singular
        end
      end

      def polymorphic_default_representer(model_name)
        "::API::V3::#{model_name.plural.camelize}::#{model_name.singular.camelize}Representer".constantize
      end
    end
  end
end
