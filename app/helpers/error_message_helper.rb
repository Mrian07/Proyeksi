#-- encoding: UTF-8



module ErrorMessageHelper
  def error_messages_for(*params)
    objects, options = extract_objects_from_params(params)

    error_messages = objects.map { |o| o.errors.full_messages }.flatten

    render_error_messages_partial(error_messages, options)
  end

  # Will take a contract to display the errors in a rails form.
  # In order to have faulty field highlighted, the method sets
  # all errors in the contract on the object as well.
  def error_messages_for_contract(object, errors)
    return unless errors

    error_messages = errors.full_messages

    object.errors.merge!(errors)

    render_error_messages_partial(error_messages, object: object)
  end

  def extract_objects_from_params(params)
    options = params.extract_options!.symbolize_keys

    objects = Array.wrap(options.delete(:object) || params).map do |object|
      object = instance_variable_get("@#{object}") unless object.respond_to?(:to_model)
      object = convert_to_model(object)
      options[:object] ||= object

      object
    end

    [objects.compact, options]
  end

  def render_error_messages_partial(messages, options)
    unless messages.empty?
      render partial: 'common/validation_error',
             locals: { error_messages: messages,
                       classes: options[:classes],
                       object_name: options[:object].class.model_name.human }
    end
  end
end
