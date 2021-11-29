#-- encoding: UTF-8



module API
  module V3
    module WorkPackages
      class PrincipalSetter
        def self.lambda(name, property_name = name)
          ->(args) {
            lambda = ::API::V3::Principals::PrincipalRepresenterFactory
                     .create_setter_lambda(name,
                                           property_name: property_name,
                                           namespaces: %i(groups users placeholder_users))

            instance_exec(**args, &lambda)
          }
        end
      end
    end
  end
end
