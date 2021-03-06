#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class RelativeLinkFilter < HTML::Pipeline::Filter
      def call
        # We only care for absolute rendering
        unless context[:only_path] == false
          return doc
        end

        rewriter = ::ProyeksiApp::TextFormatting::Helpers::LinkRewriter.new context
        doc.css('a[href^="/"]').each do |node|
          node['href'] = rewriter.replace node['href']
        end

        doc
      end
    end
  end
end
