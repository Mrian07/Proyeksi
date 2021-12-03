module AttachableServiceCall
  ##
  # Call the presented CreateContract service
  # with the given params, merging in any attachment params
  #
  # @param service_cls the service class instance
  # @param args permitted args for the service call
  def attachable_create_call(service_cls, args:)
    service_cls
      .new(user: current_user)
      .call(args.merge(attachment_params))
  end

  ##
  # Call the presented UpdateContract service
  # with the given params, merging in any attachment params
  #
  # @param service_cls the service class instance
  # @param args permitted args for the service call
  def attachable_update_call(service_cls, model:, args:)
    service_cls
      .new(user: current_user, model: model)
      .call(args.merge(attachment_params))
  end

  ##
  # Attachable parameters mapped to a format the
  # SetReplacements service concern
  def attachment_params
    attachment_params = permitted_params.attachments.to_h

    if attachment_params.any?
      { attachment_ids: attachment_params.values.map(&:values).flatten }
    else
      {}
    end
  end
end
