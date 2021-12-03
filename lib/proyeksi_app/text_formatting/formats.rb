#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Formats
    class << self
      attr_reader :plain, :rich

      %i(plain rich).each do |flavor|
        define_method("#{flavor}_format") do
          send(flavor).format
        end

        define_method("#{flavor}_formatter") do
          send(flavor).formatter
        end

        define_method("#{flavor}_helper") do
          send(flavor).helper
        end

        define_method("register_#{flavor}!") do |klass|
          instance_variable_set("@#{flavor}", klass)
        end
      end

      def supported?(name)
        [plain, rich].map(&:format).include?(name.to_sym)
      end

      def plain?(name)
        name && plain.format == name.to_sym
      end
    end
  end
end

ProyeksiApp::TextFormatting::Formats.register_plain! ::ProyeksiApp::TextFormatting::Formats::Plain::Format
ProyeksiApp::TextFormatting::Formats.register_rich! ::ProyeksiApp::TextFormatting::Formats::Markdown::Format
