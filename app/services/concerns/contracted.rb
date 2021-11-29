#-- encoding: UTF-8



module Contracted
  extend ActiveSupport::Concern

  included do
    attr_reader :contract_class
    attr_accessor :contract_options

    def contract_class=(cls)
      unless cls <= ::BaseContract
        raise ArgumentError, "#{cls.name} is not an instance of BaseContract."
      end

      @contract_class = cls
    end

    private

    def instantiate_contract(object, user, options: {})
      contract_class.new(object, user, options: options)
    end

    def validate_and_save(object, user, options: {})
      validate_and_yield(object, user, options: options) do
        object.save
      end
    end

    ##
    # Call the given block and assume object is erroneous if
    # it does not return truthy
    def validate_and_yield(object, user, options: {})
      contract = instantiate_contract(object, user, options: options)

      if !contract.validate
        [false, contract.errors]
      else
        success = !!yield
        [success, object&.errors]
      end
    end

    def validate(object, user, options: {})
      validate_and_yield(object, user, options: options) do
        # No object validation is necessary at this point
        # as object.valid? is already called in the contract
        true
      end
    end
  end
end
