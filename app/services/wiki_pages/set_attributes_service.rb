#-- encoding: UTF-8



# Handles setting the attributes of a wiki page.
# The wiki page is treated as one single entity although the data layer separates
# between the page and the content.
#
# In the long run, those two should probably be unified on the data layer as well.
#
# Attributes for both the page as well as for the content are accepted.
class WikiPages::SetAttributesService < ::BaseServices::SetAttributes
  include Attachments::SetReplacements

  private

  def set_attributes(params)
    content_params, page_params = split_page_and_content_params(params.with_indifferent_access)

    set_page_attributes(page_params)

    set_default_attributes(params) if model.new_record?

    set_content_attributes(content_params)
  end

  def set_page_attributes(params)
    model.attributes = params
  end

  def set_default_attributes(_params)
    model.build_content page: model
    model.content.extend(OpenProject::ChangedBySystem)

    model.content.change_by_system do
      model.content.author = user
    end
  end

  def set_content_attributes(params)
    model.content.attributes = params
  end

  def split_page_and_content_params(params)
    params.partition { |p, _| content_attribute?(p) }.map(&:to_h)
  end

  def content_attribute?(name)
    WikiContent.column_names.include?(name) || name.to_s == 'journal_notes'
  end
end
