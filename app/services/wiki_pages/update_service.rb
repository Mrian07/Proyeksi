#-- encoding: UTF-8

class WikiPages::UpdateService < ::BaseServices::Update
  include Attachments::ReplaceAttachments

  protected

  def persist(service_result)
    service_result = super(service_result)

    page = service_result.result
    content = page.content

    unless page.save && content.save
      service_result.errors = page.errors
      service_result.errors.merge! content.errors
      service_result.success = false
    end

    service_result
  end
end
