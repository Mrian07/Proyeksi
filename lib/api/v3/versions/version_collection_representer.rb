#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json'
require 'roar/json/collection'
require 'roar/json/hal'

module API
  module V3
    module Versions
      class VersionCollectionRepresenter < ::API::Decorators::UnpaginatedCollection
        link :createVersionImmediately do
          next unless current_user.allowed_to_globally?(:manage_versions)

          {
            href: api_v3_paths.versions,
            method: :post
          }
        end

        link :createVersion do
          next unless current_user.allowed_to_globally?(:manage_versions)

          {
            href: api_v3_paths.create_version_form,
            method: :post
          }
        end
      end
    end
  end
end
