#-- encoding: UTF-8



module BaseServices
  class Update < Write
    def initialize(user:, model:, contract_class: nil, contract_options: {})
      self.model = model
      super(user: user, contract_class: contract_class, contract_options: contract_options)
    end

    private

    def instance(_params)
      model
    end

    def default_contract_class
      "#{namespace}::UpdateContract".constantize
    end
  end
end
