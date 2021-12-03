#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module Attachments
      class AttachmentParsingRepresenter < ::API::Decorators::Single
        nested :metadata do
          property :filename,
                   as: :fileName

          property :description,
                   getter: ->(*) {
                     ::API::Decorators::Formattable.new(description, plain: true)
                   },
                   setter: ->(fragment:, **) { self.description = fragment['raw'] },
                   render_nil: true

          property :content_type,
                   as: :contentType,
                   render_nil: false

          property :filesize,
                   as: :fileSize,
                   render_nil: false

          property :digest,
                   render_nil: false
        end

        property :file,
                 setter: ->(fragment:, represented:, doc:, **) {
                   filename = represented.filename || doc.dig('metadata', 'fileName')
                   self.file = ProyeksiApp::Files.build_uploaded_file fragment[:tempfile],
                                                                      fragment[:type],
                                                                      file_name: filename
                 }
      end
    end
  end
end
