#-- encoding: UTF-8



module OpenProject::TextFormatting
  module Matchers
    # OpenProject attribute macros syntax
    # Examples:
    #   workPackageLabel:1234:subject # Outputs work package label attribute "Subject" + help text
    #   workPackageValue:1234:subject # Outputs the actual subject of #1234
    #
    #   projectLabel:statusExplanation # Outputs current project label attribute "Status description" + help text
    #   projectValue:statusExplanation # Outputs current project value for "Status description"
    class AttributeMacros < RegexMatcher
      def self.regexp
        %r{
          (\w+)(Label|Value) # The model type we try to reference
          (?::(?:([^"\s]+)|"([^"]+)"))? # Optional: An ID or subject reference
          (?::([^"\s.]+|"([^".]+)")) # The attribute name we're trying to reference
        }x
      end

      ##
      # Faster inclusion check before the regex is being applied
      def self.applicable?(content)
        content.include?('Label:') || content.include?('Value:')
      end

      def self.process_match(m, _matched_string, _context)
        # Leading string before match
        macro_attributes = {
          model: m[1],
          id: m[4] || m[3],
          attribute: m[6] || m[5]
        }
        type = m[2].downcase

        ApplicationController.helpers.content_tag :macro,
                                                  '',
                                                  class: "macro--attribute-#{type}",
                                                  data: macro_attributes
      end
    end
  end
end
