#-- encoding: UTF-8



class Grids::UpdateService < ::BaseServices::Update
  protected

  def perform(attributes)
    set_type_for_error_message(attributes.delete(:scope))

    super
  end

  def after_perform(service_call)
    model.touch if only_widgets_updated?

    super
  end

  def only_widgets_updated?
    !model.saved_changes? && model.widgets.any?(&:saved_changes?)
  end

  # Changing the scope/type after the grid has been created is prohibited.
  # But we set the value so that an error message can be displayed
  def set_type_for_error_message(scope)
    if scope
      grid_class = ::Grids::Configuration.class_from_scope(scope)
      model.type = grid_class.name
    end
  end
end
