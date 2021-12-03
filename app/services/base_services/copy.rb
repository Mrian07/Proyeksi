#-- encoding: UTF-8

module BaseServices
  class Copy < ::BaseServices::BaseContracted
    alias_attribute(:source, :model)

    ##
    # dependent services to copy associations
    def self.copy_dependencies
      []
    end

    ##
    # collect copyable associated modules
    def self.copyable_dependencies
      copy_dependencies.map do |service_cls|
        {
          identifier: service_cls.identifier,
          name_source: -> { service_cls.human_name },
          count_source: ->(source, user) do
            service_cls
              .new(source: source, target: nil, user: user)
              .source_count
          end
        }
      end
    end

    def initialize(user:, source: nil, model: nil, contract_class: nil, contract_options: {})
      self.source = source || model
      raise ArgumentError, "Missing source object" if self.source.nil?

      contract_options[:copy_source] = self.source
      super(user: user, contract_class: contract_class, contract_options: contract_options)
    end

    def call(params)
      User.execute_as(user) do
        prepare(params)
        perform(params)
      end
    end

    def after_validate(params, _call)
      # Initialize the target resource to copy into
      call = initialize_copy(source, params)

      # Return only the unsaved copy
      return call if params[:attributes_only]

      # Try to save the result or return its errors
      copy_instance = call.result
      unless copy_instance.save
        return ServiceResult.new(success: false, result: copy_instance, errors: copy_instance.errors)
      end

      self.class.copy_dependencies.each do |service_cls|
        next if skip_dependency?(params, service_cls)

        call.merge! call_dependent_service(service_cls, target: copy_instance, params: params),
                    without_success: true
      end

      call
    end

    protected

    ##
    # Disabling sending regular notifications
    def service_context(&block)
      in_context(model, false, &block)
    end

    ##
    # Should the dependency be skipped for this service run?
    def skip_dependency?(_params, _dependency_cls)
      false
    end

    ##
    # Sets up a state object that gets
    # passed around to all service calls from here
    #
    # Note that for dependent copy services to be called
    # this will already be present.
    def prepare(_params)
      # Retain the source project itself
      state.source = source
    end

    ##
    # Calls a dependent service with the source and copy instance
    def call_dependent_service(service_cls, target:, params:)
      service_cls
        .new(source: source, target: target, user: user)
        .with_state(state)
        .call(params: params)
    end

    def initialize_copy(source, params)
      raise NotImplementedError
    end

    def default_contract_class
      "#{namespace}::CopyContract".constantize
    end
  end
end
