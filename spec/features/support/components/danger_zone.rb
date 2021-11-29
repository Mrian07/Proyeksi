

class DangerZone
  include Capybara::DSL

  attr_reader :page

  def initialize(page)
    @page = page
  end

  def container_selector
    '.danger-zone--verification'
  end

  def confirmation_field
    page.within container_selector do
      find('input[type=text]')
    end
  end

  def danger_button
    page.within container_selector do
      find('button.-highlight')
    end
  end

  def cancel_button
    page.within container_selector do
      find('a.icon-cancel')
    end
  end

  ##
  # Set the confirmation field to the given value
  def confirm_with(value)
    confirmation_field.set value
  end

  ##
  def disabled?
    danger_button.disabled?
  end
end
