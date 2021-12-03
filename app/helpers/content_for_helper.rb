#-- encoding: UTF-8

module ContentForHelper
  # Thanks to http://blog.plataformatec.com.br/2012/07/flushing-content-blocks-with-rails-4/
  # TODO: This method becomes obsolete with Rails 4 and the 'flush' parameter
  def single_content_for(name, content = nil, &block)
    @view_flow.set(name, ActiveSupport::SafeBuffer.new)
    content_for(name, content, &block)
  end
end
