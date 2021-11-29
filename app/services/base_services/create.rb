#-- encoding: UTF-8



module BaseServices
  class Create < Write
    protected

    def service_context(&block)
      in_user_context(true, &block)
    end

    def instance(_params)
      instance_class.new
    end

    def default_contract_class
      "#{namespace}::CreateContract".constantize
    end
  end
end
