
# Modifications:
# - sensible default changed to "application/binary"
# - removed references to paperclip

require 'open3'

module OpenProject
  class FileCommandContentTypeDetector
    SENSIBLE_DEFAULT = 'application/binary'

    def initialize(filename)
      @filename = filename
    end

    def detect
      type_from_file_command
    end

    private

    def type_from_file_command
      # On BSDs, `file` doesn't give a result code of 1 if the file doesn't exist.
      type, status = Open3.capture2('file', '-b', '--mime', @filename)

      if type.nil? || status.to_i > 0 || type.match(/\(.*?\)/)
        type = SENSIBLE_DEFAULT
      end
      type.split(/[:;\s]+/)[0]
    rescue StandardError => e
      Rails.logger.info { "Failed to get mime type from #{@filename}: #{e} #{e.message}" }
      SENSIBLE_DEFAULT
    end
  end
end
