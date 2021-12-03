module Notifications
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_default_attributes(params)
      super

      set_default_project unless model.project
    end

    ##
    # Try to determine the project context from the journal (if any)
    # or the resource if it has a project set
    def set_default_project
      model.project = model.journal&.project || model.resource.try(:project)
    end
  end
end
