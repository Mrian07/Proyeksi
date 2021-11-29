

class ParamsContract < BaseContract
  attr_reader :params

  def initialize(model, user, params:, options: {})
    super(model, user, options: options)

    @params = params
  end
end
