#-- encoding: UTF-8



module ProyeksiApp
  module TextFormatting
    include ::ProyeksiApp::TextFormatting::Truncation

    # Formats text according to system settings.
    # 2 ways to call this method:
    # * with a String: format_text(text, options)
    # * with an object and one of its attribute: format_text(issue, :description, options)
    def format_text(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      case args.size
      when 1
        attribute = nil
        object = options[:object]
        text = args.shift
      when 2
        object = args.shift
        attribute = args.shift
        text = object.send(attribute).to_s
      else
        raise ArgumentError, 'invalid arguments to format_text'
      end
      return '' if text.blank?

      project = options.delete(:project) { @project || object.try(:project) }
      only_path = options.delete(:only_path) != false
      current_user = options.delete(:current_user) { User.current }

      plain = ::ProyeksiApp::TextFormatting::Formats.plain?(options.delete(:format))

      Renderer.format_text text,
                           options.merge(
                             plain: plain,
                             object: object,
                             request: try(:request),
                             current_user: current_user,
                             attribute: attribute,
                             only_path: only_path,
                             project: project
                           )
    end
  end
end
