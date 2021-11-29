#-- encoding: UTF-8



# Extending Capybara to allow a flagged check for has_selector to avoid
# lots of if/else

module Capybara
  class Session
    def has_conditional_selector?(condition, *args)
      if condition
        has_selector? *args
      else
        has_no_selector? *args
      end
    end
  end
end
