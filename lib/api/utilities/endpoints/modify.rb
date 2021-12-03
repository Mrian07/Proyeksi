module API
  module Utilities
    module Endpoints
      class Modify < Bodied
        def default_instance_generator(model)
          ->(_params, _current_user) do
            instance_variable_get("@#{model.name.demodulize.underscore}")
          end
        end

        private

        def present_success(_request, _call)
          raise NotImplementedError
        end

        def present_error(call)
          api_errors = [::API::Errors::ErrorBase.create_and_merge_errors(postprocess_errors(call))]

          fail(::API::Errors::MultipleErrors
                 .create_if_many(api_errors))
        end

        def postprocess_errors(call)
          errors = call.errors
          errors = merge_dependent_errors call if errors.empty?
          errors
        end

        def merge_dependent_errors(call)
          errors = ActiveModel::Errors.new call.result

          call.dependent_results.each do |dr|
            dr.errors.full_messages.each do |full_message|
              errors.add :base, :dependent_invalid, message: dependent_error_message(dr.result, full_message)
            end
          end

          errors
        end

        def dependent_error_message(result, full_message)
          I18n.t(
            :error_in_dependent,
            dependent_class: result.model_name.human,
            related_id: result.id,
            related_subject: result.name,
            error: full_message
          )
        end

        def deduce_process_service
          "::#{deduce_backend_namespace}::#{update_or_create}Service".constantize
        end

        def deduce_process_contract
          nil
        end
      end
    end
  end
end
