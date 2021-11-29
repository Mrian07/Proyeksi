

module PageObjects
  class Notifications
    include RSpec::Matchers

    attr_accessor :page

    def initialize(page)
      @page = page
    end

    def expect_type(type, message)
      raise "Unimplemented type #{type}." unless types.include?(type)

      expect(page).to have_selector(".op-toast.-#{type}", text: message, wait: 10)
    end

    def expect_success(message)
      expect_type(:success, message)
    end

    def expect_error(message)
      expect_type(:error, message)
    end

    private

    def types
      %i[success error]
    end
  end
end
