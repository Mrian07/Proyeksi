

module API::V3::Formatter
  class TxtCharset
    def self.call(object, env)
      encoding = encoding(object, env)

      object.force_encoding(encoding)
    end

    # Returns the encoding of
    # * the content type (charset) if provided and valid or
    # * the objects encoding if provided and invalid
    # * Encoding.default_external if no charset provided
    def self.encoding(object, env)
      Encoding.find(charset(env))
    rescue StandardError
      object.encoding
    end
    private_class_method :encoding

    # Detects the charset in the content_type header.
    # If no charset is defined, the default_external encoding is assumed.
    #
    # This might return an invalid charset as only pattern matching is applied.
    def self.charset(env)
      content_type = env['CONTENT_TYPE'].to_s

      if (matches = content_type.match(/charset=([^\s;]+)/))
        matches[1]
      else
        Encoding.default_external
      end
    end
    private_class_method :charset
  end
end
