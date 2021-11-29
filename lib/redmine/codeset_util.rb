

module Redmine
  module CodesetUtil
    def self.replace_invalid_utf8(str)
      return str if str.nil?

      str.force_encoding('UTF-8')
      if str.valid_encoding?
        str
      else
        str.encode('US-ASCII',
                   invalid: :replace,
                   undef: :replace,
                   replace: '?')
           .encode('UTF-8')
      end
    end

    def self.to_utf8(str, encoding)
      return str if str.nil?

      str.force_encoding('ASCII-8BIT')
      if str.empty?
        str.force_encoding('UTF-8')
        return str
      end
      enc = encoding.blank? ? 'UTF-8' : encoding
      if enc.upcase != 'UTF-8'
        str.force_encoding(enc)
        str = str.encode('UTF-8', invalid: :replace,
                                  undef: :replace, replace: '?')
      else
        str.force_encoding('UTF-8')
        if !str.valid_encoding?
          str = str.encode('US-ASCII', invalid: :replace,
                                       undef: :replace, replace: '?').encode('UTF-8')
        end
      end
      str
    end

    def self.from_utf8(str, encoding)
      str ||= ''
      str = str.dup if str.frozen?
      str.force_encoding('UTF-8')
      if encoding.upcase != 'UTF-8'
        str.encode(encoding,
                   invalid: :replace,
                   undef: :replace,
                   replace: '?')
      else
        replace_invalid_utf8(str)
      end
    end
  end
end
