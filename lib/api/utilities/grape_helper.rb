#-- encoding: UTF-8



module API
  module Utilities
    module GrapeHelper
      ##
      # We need this to be able to use `Grape::Middleware::Error#error_response`
      # outside of the Grape context. We use it outside of the Grape context because
      # ProyeksiApp authentication happens in a middleware upstream of Grape.
      class GrapeError < Grape::Middleware::Error
        def initialize(env)
          @env = env
          @options = {}
        end
      end

      def grape_error_for(env, api)
        GrapeError.new(env).tap do |e|
          e.options[:content_types] = api.content_types
          e.options[:format] = 'hal+json'
        end
      end

      def error_response(rescued_error, error = nil, rescue_subclasses: nil, headers: -> { {} }, log: true)
        error_response_lambda = default_error_response(headers, log)

        response =
          if error.nil?
            error_response_lambda
          else
            lambda { |e| instance_exec error.new(e.message, exception: e), &error_response_lambda }
          end

        # We do this lambda business because #rescue_from behaves differently
        # depending on the number of parameters the passed block accepts.
        rescue_from rescued_error, rescue_subclasses: rescue_subclasses, &response
      end

      def default_error_response(headers, log)
        lambda { |e|
          original_exception = $!
          representer = error_representer.new e
          resp_headers = instance_exec &headers
          env['api.format'] = error_content_type

          if log == true
            ProyeksiApp.logger.error original_exception, reference: :APIv3
          elsif log.respond_to?(:call)
            log.call(original_exception)
          end

          error_response status: e.code, message: representer.to_json, headers: resp_headers
        }
      end
    end
  end
end
