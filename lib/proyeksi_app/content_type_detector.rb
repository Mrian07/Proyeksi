
#
# Modifications:
# - sensible default changed to "application/binary"
# - removed references to paperclip

#
# The content-type detection strategy is as follows:
#
# 1. Blank/Empty files: If there's no filename or the file is empty,
#    provide a sensible default (application/binary or inode/x-empty)
#
# 2. Calculated match: Return the first result that is found by both the
#    `file` command and MIME::Types.
#
# 3. Standard types: Return the first standard (without an x- prefix) entry
#    in MIME::Types
#
# 4. Experimental types: If there were no standard types in MIME::Types
#    list, try to return the first experimental one
#
# 5. Raw `file` command: Just use the output of the `file` command raw, or
#    a sensible default. This is cached from Step 2.
#
module ProyeksiApp
  class ContentTypeDetector
    # application/binary is more secure than application/octet-stream
    # see: http://security.stackexchange.com/q/12896
    SENSIBLE_DEFAULT = 'application/binary'
    EMPTY_TYPE = 'inode/x-empty'

    def initialize(filename)
      @filename = filename
    end

    # Returns a String describing the file's content type
    def detect
      if blank_name?
        SENSIBLE_DEFAULT
      elsif empty_file?
        EMPTY_TYPE
      elsif calculated_type_matches.any?
        calculated_type_matches.first
      else
        type_from_file_command || SENSIBLE_DEFAULT
      end.to_s
    end

    private

    def empty_file?
      File.exists?(@filename) && File.size(@filename) == 0
    end

    alias :empty? :empty_file?

    def blank_name?
      @filename.nil? || @filename.empty?
    end

    def possible_types
      MIME::Types.type_for(@filename).map(&:content_type)
    end

    def calculated_type_matches
      possible_types.select { |content_type| content_type == type_from_file_command }
    end

    def type_from_file_command
      @type_from_file_command ||= FileCommandContentTypeDetector.new(@filename).detect
    end
  end
end
