#-- encoding: UTF-8



module DocumentsHelper
  def api_v3_document_resource(document)
    ::API::V3::Documents::DocumentRepresenter.new(document,
                                                  current_user: current_user,
                                                  embed_links: true)
  end
end
