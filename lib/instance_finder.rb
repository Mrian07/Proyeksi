

class InstanceFinder
  def self.register(model, method)
    @model_method_map ||= {}

    @model_method_map[model] = method
  end

  def self.find(model, identifier)
    if @model_method_map[model].nil?
      raise "#{model} is not registered with InstanceFinder"
    end

    @model_method_map[model].call(identifier)
  end
end
