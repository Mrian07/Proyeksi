

class DocumentsMailer < UserMailer
  def document_added(user, document)
    @document = document

    proyeksi_app_headers 'Project' => @document.project.identifier,
                         'Type' => 'Document'

    with_locale_for(user) do
      subject = "[#{@document.project.name}] #{t(:label_document_new)}: #{@document.title}"
      mail to: user.mail, subject: subject
    end
  end

  def attachments_added(user, attachments)
    container = attachments.first.container

    @added_to     = "#{Document.model_name.human}: #{container.title}"
    @added_to_url = url_for(controller: '/documents', action: 'show', id: container.id)

    super
  end
end
