#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class PatternMatcherFilter < HTML::Pipeline::Filter
      # Skip text nodes that are within preformatted blocks
      PREFORMATTED_BLOCKS = %w(pre code).to_set

      def self.matchers
        [
          ProyeksiApp::TextFormatting::Matchers::ResourceLinksMatcher,
          ProyeksiApp::TextFormatting::Matchers::WikiLinksMatcher,
          ProyeksiApp::TextFormatting::Matchers::AttributeMacros
        ]
      end

      def call
        doc.search('.//text()').each do |node|
          next if has_ancestor?(node, PREFORMATTED_BLOCKS)

          self.class.matchers.each do |matcher|
            matcher.call(node, doc: doc, context: context)
          end
        end

        doc
      end
    end
  end
end
