#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Filters
    class LinkAttributeFilter < HTML::Pipeline::Filter
      def call
        links.each do |node|
          node['target'] = context[:target] if context[:target].present?
        end

        doc
      end

      def links
        doc.xpath(".//a[contains(@href,'/')]")
      end
    end
  end
end
