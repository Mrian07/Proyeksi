#-- encoding: UTF-8

module API
  module V3
    module Principals
      class PrincipalRepresenterFactory
        ##
        # Create the appropriate subclass representer
        # for each principal entity
        def self.create(model, **args)
          representer_class(model)
            .create(model, **args)
        end

        def self.representer_class(model)
          case model
          when User
            ::API::V3::Users::UserRepresenter
          when Group
            ::API::V3::Groups::GroupRepresenter
          when PlaceholderUser
            ::API::V3::PlaceholderUsers::PlaceholderUserRepresenter
          else
            raise ArgumentError, "Missing concrete principal representer for #{model}"
          end
        end

        def self.create_link_lambda(name, getter: "#{name}_id")
          ->(*) {
            v3_path = API::V3::Principals::PrincipalType.for(represented.send(name))

            instance_exec(&self.class.associated_resource_default_link(name,
                                                                       v3_path: v3_path,
                                                                       skip_link: -> { false },
                                                                       title_attribute: :name,
                                                                       getter: getter))
          }
        end

        def self.create_setter_lambda(name, property_name: name, namespaces: %i(groups users placeholder_users))
          ->(fragment:, **) {
            ::API::Decorators::LinkObject
              .new(represented,
                   property_name: property_name,
                   namespace: namespaces,
                   getter: :"#{name}_id",
                   setter: :"#{name}_id=")
              .from_hash(fragment)
          }
        end

        def self.create_getter_lambda(name)
          ->(*) {
            next unless embed_links

            instance = represented.send(name)
            next if instance.nil?

            ::API::V3::Principals::PrincipalRepresenterFactory
              .create(represented.send(name), current_user: current_user)
          }
        end
      end
    end
  end
end
