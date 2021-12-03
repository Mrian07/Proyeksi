#-- encoding: UTF-8



module ProyeksiApp
  class Footer
    class << self
      attr_accessor :content

      def add_content(name, footer_element)
        self.content = {} if content.nil?
        content[name] = footer_element
      end
    end
  end
end
