#-- encoding: UTF-8



require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Watchers
      class WatcherRepresenter < ::API::Decorators::Single
        def initialize(user)
          super(user, current_user: nil)
        end

        property :user,
                 exec_context: :decorator,
                 getter: ->(*) {
                   create_link_representer
                 },
                 setter: ->(fragment:, **) {
                   link = create_link_representer
                   link.from_hash(fragment)
                 }

        private

        def create_link_representer
          ::API::Decorators::LinkObject.new(represented,
                                            property_name: :user)
        end
      end
    end
  end
end
