

require 'support/pages/page'

module Pages::Messages
  class Base < ::Pages::Page
    def toast_type
      :rails
    end
  end
end
