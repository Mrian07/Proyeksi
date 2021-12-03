#-- encoding: UTF-8

module AngularHelper
  ##
  # Create a component element tag with the given attributes
  #
  # Allow setting dynamic inputs for components with the @DatasetInputs decorator
  # by using inputs: { inputName: value }
  def angular_component_tag(component, options = {})
    inputs = (options.delete(:inputs) || {})
               .transform_keys { |k| k.to_s.underscore.dasherize }
               .transform_values(&:to_json)

    options[:data] = options.fetch(:data, {}).merge(inputs)
    options[:class] ||= "#{options.fetch(:class, '')} op-angular-component"

    content_tag(component, '', options)
  end
end
