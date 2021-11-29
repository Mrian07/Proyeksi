#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Matchers
    class RegexMatcher
      def self.call(node, doc:, context:)
        content = node.to_html
        return unless applicable?(content)

        # Replace the content
        if process_node!(content, context)
          node.replace(content)
        end
      rescue RuntimeError
        # If an error is occurred, instead of failing hard, simply do not replace.
      end

      ##
      # Quick bypass method if the content is not applicable for this matcher
      def self.applicable?(_content)
        true
      end

      ##
      # Process the node's html and possibly, replace it
      def self.process_node!(content, context)
        return nil unless content.present?

        content.gsub!(regexp) do |matched_string|
          matchdata = Regexp.last_match
          process_match matchdata, matched_string, context
        end
      end

      ##
      # Get the regexp that matches the content
      def self.regexp
        raise NotImplementedError
      end

      ##
      # Called with a match from the regexp on the node's content
      def self.process_match(matchdata, matched_string, context)
        raise NotImplementedError
      end

      ##
      # Helper method for url helpers
      def controller; end
    end
  end
end
