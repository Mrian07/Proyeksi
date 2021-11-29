#-- encoding: UTF-8



module TextFormattingHelper
  extend Forwardable
  def_delegators :current_formatting_helper,
                 :wikitoolbar_for

  def preview_context(object, project = nil)
    if object.new_record?
      project_preview_context(object, project)
    elsif object.is_a? Message
      message_preview_context(object)
    else
      object_preview_context(object, project)
    end
  end

  # TODO remove
  def current_formatting_helper
    helper_class = OpenProject::TextFormatting::Formats.rich_helper
    helper_class.new(self)
  end

  def project_preview_context(object, project)
    relevant_project = if project
                         project
                       elsif object.respond_to?(:project) && object.project
                         object.project
                       end

    return nil unless relevant_project

    API::V3::Utilities::PathHelper::ApiV3Path
      .project(relevant_project.id)
  end

  def message_preview_context(message)
    API::V3::Utilities::PathHelper::ApiV3Path
      .post(message.id)
  end

  def object_preview_context(object, project)
    paths = API::V3::Utilities::PathHelper::ApiV3Path

    if paths.respond_to?(object.class.name.underscore.singularize)
      paths.send(object.class.name.underscore.singularize, object.id)
    else
      project_preview_context(object, project)
    end
  end
end
