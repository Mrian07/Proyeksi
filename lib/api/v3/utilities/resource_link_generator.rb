#-- encoding: UTF-8



module API
  module V3
    module Utilities
      module ResourceLinkGenerator
        class << self
          include ::API::V3::Utilities::PathHelper

          def make_link(record)
            if record.respond_to?(:id)
              path_method = determine_path_method(record)
              record_identifier = record.id
              api_v3_paths.send(path_method, record_identifier)
            end
          rescue NoMethodError
            nil
          end

          private

          def determine_path_method(record)
            # since not all things are equally named between APIv3 and the rails code,
            # we need to convert some names manually
            case record
            when Project
              :project
            when IssuePriority
              :priority
            when AnonymousUser, DeletedUser, SystemUser
              :user
            when Journal
              :activity
            when Changeset
              :revision
            else
              record.class.model_name.singular
            end
          end
        end
      end
    end
  end
end
