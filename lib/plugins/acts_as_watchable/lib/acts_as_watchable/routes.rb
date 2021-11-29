

module OpenProject
  module Acts
    module Watchable
      module Routes
        mattr_accessor :models

        def self.matches?(request)
          params = request.path_parameters

          watched?(params[:object_type]) &&
            /\d+/.match(params[:object_id])
        end

        def self.watched?(object)
          watchable_object? object
        end

        def self.watchable_object?(object)
          klass = object.to_s.classify.constantize
          klass.included_modules.include? Redmine::Acts::Watchable
        rescue StandardError
          false
        end
      end
    end
  end
end
