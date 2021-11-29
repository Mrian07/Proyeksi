#-- encoding: UTF-8



##
# Dependent service to be executed under the BaseServices::Copy service
module Copy
  class Dependency < ::BaseServices::BaseCallable
    attr_reader :source,
                :target,
                :user,
                :result

    ##
    # Identifier of this dependency to include/exclude
    def self.identifier
      name.demodulize.gsub('DependentService', '').underscore
    end

    ##
    # Localizable human name used in errors
    def self.human_name
      identifier.capitalize
    end

    def initialize(source:, target:, user:)
      @source = source
      @target = target
      @user = user
      # Create a result with an empty error set
      # that we can merge! so that not the target.errors object is reused.
      @result = ServiceResult.new(result: target, success: true, errors: ActiveModel::Errors.new(target))
    end

    protected

    ##
    # Merge some other model's errors with the result errors
    def add_error!(model, errors, model_name: human_model_name(model))
      result.errors.add(:base, "#{model_name}: #{error_messages(errors)}")
    end

    def human_model_name(model)
      "#{model.class.model_name.human} '#{model}'"
    end

    def error_messages(errors)
      errors.full_messages.join(". ")
    end

    def perform(params:)
      begin
        copy_dependency(params: params)
      rescue StandardError => e
        Rails.logger.error { "Failed to copy dependency #{self.class.identifier}: #{e.message}" }
        result.success = false
        result.errors.add(:base, :could_not_be_copied, dependency: self.class.human_name)
      end

      result
    end

    def copy_dependency(params:)
      raise NotImplementedError
    end
  end
end
