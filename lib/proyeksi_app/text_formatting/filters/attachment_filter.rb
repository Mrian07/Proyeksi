#-- encoding: UTF-8



module ProyeksiApp::TextFormatting
  module Filters
    class AttachmentFilter < HTML::Pipeline::Filter
      include ProyeksiApp::StaticRouting::UrlHelpers
      include ProyeksiApp::ObjectLinking

      def matched_filenames_regex
        /(bmp|gif|jpe?g|png|svg)\z/
      end

      def call
        attachments = get_attachments

        rewriter = ::ProyeksiApp::TextFormatting::Helpers::LinkRewriter.new context

        doc.css('img[src]').each do |node|
          # Check for relative URLs and replace them if needed
          if rewriter.applicable? node['src']
            node['src'] = rewriter.replace node['src']
            next
          end

          # Don't try to lookup attachments if we don't have any
          next if attachments.nil?

          # We allow linking to filenames that are replaced with their attachment URL
          lookup_attachment_by_name node, attachments
        end

        doc
      end

      ##
      # Lookup a local attachment name
      def lookup_attachment_by_name(node, attachments)
        filename = node['src'].downcase

        # We only match a specific set of attributes as before
        return unless filename =~ matched_filenames_regex

        # Try to find the attachment
        if (attachment = attachments.detect { |att| att.filename.downcase == filename })
          node['src'] = url_to_attachment(attachment, only_path: context[:only_path])

          # Replace alt text with description, unless it has one already
          node['alt'] = node['alt'].presence || attachment.description
        end
      end

      def get_attachments
        attachments = context[:attachments] || context[:object].try(:attachments)

        return nil unless attachments

        attachments.sort_by(&:created_at).reverse
      end
    end
  end
end
