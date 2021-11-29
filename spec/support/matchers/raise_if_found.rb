#-- encoding: UTF-8



# Extending Capybara to check or raise for an element

module Capybara
  class Session
    def raise_if_found(condition, *args)
      raise_if_has_selector?(:has_selector?, condition, *args)
    end

    def raise_if_found_field(condition, *args)
      raise_if_has_selector?(:has_field?, condition, *args)
    end

    def raise_if_found_select(condition, *args)
      raise_if_has_selector?(:has_select?, condition, *args)
    end

    def raise_if_has_selector?(method, condition, *args)
      found = public_send(method, condition, *args)
      raise "Expected not to find field #{condition}" if found
    end
  end
end
