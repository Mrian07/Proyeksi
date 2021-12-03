#-- encoding: UTF-8

module API::V3
  class Parser
    def call(object, _env)
      MultiJson.load(object)
    rescue MultiJson::ParseError => e
      error = ::API::Errors::ParseError.new(details: e.message)
      representer = ::API::V3::Errors::ErrorRepresenter.new(error)

      throw :error, status: 400, message: representer.to_json
    end
  end
end
