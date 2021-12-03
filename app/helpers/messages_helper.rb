#-- encoding: UTF-8

module MessagesHelper
  def message_attachment_representer(message)
    ::API::V3::Posts::PostRepresenter.new(message,
                                          current_user: current_user,
                                          embed_links: true)
  end

  def message_url(message)
    topic_url(message.root, r: message.id, anchor: "message-#{message.id}")
  end
end
