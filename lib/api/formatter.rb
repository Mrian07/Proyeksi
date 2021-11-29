#-- encoding: UTF-8



module API
  class Formatter
    def call(object, _env)
      if object.is_a?(String)
        object
      elsif object.respond_to?(:to_json)
        object.to_json
      else
        MultiJson.dump(object)
      end
    end
  end
end
