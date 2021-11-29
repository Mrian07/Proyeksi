

module OpenProject::Documents
  class Engine < ::Rails::Engine
    engine_name :openproject_documents

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-documents',
             author_url: "http://www.openproject.org",
             bundled: true do
      menu :project_menu,
           :documents,
           { controller: '/documents', action: 'index' },
           caption: :label_document_plural,
           before: :members,
           icon: 'icon2 icon-notes'

      project_module :documents do |_map|
        permission :view_documents, documents: %i[index show download]
        permission :manage_documents, {
          documents: %i[new create edit update destroy]
        }, require: :loggedin
      end

      Redmine::Search.register :documents
    end

    activity_provider :documents, class_name: 'Activities::DocumentActivityProvider', default: false

    patches %i[Project]

    add_api_path :documents do
      "#{root}/documents"
    end

    add_api_path :document do |id|
      "#{root}/documents/#{id}"
    end

    add_api_path :attachments_by_document do |id|
      "#{document(id)}/attachments"
    end

    add_api_endpoint 'API::V3::Root' do
      mount ::API::V3::Documents::DocumentsAPI
    end

    # Add documents to allowed search params
    additional_permitted_attributes search: %i(documents)

    config.to_prepare do
      require_dependency 'document'
      require_dependency 'document_category'

      require_dependency 'open_project/documents/patches/textile_converter_patch'
    end
  end
end
