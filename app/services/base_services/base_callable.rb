#-- encoding: UTF-8

module BaseServices
  class BaseCallable
    extend ActiveModel::Callbacks
    define_model_callbacks :call

    include ::WithReversibleState

    def call(*params)
      self.params = params.first

      run_callbacks(:call) do
        perform(*params)
      end
    end

    protected

    attr_accessor :params

    def perform(*)
      raise NotImplementedError
    end
  end
end
