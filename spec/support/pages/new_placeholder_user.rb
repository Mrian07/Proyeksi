

require 'support/pages/page'

module Pages
  class NewPlaceholderUser < Page
    def path
      '/placeholder_users/new'
    end

    ##
    # Fills in the given user form fields.
    def fill_in!(fields = {})
      form = FormFiller.new fields

      form.fill! 'Name', :name
    end

    def submit!
      click_button 'Create'
    end
  end
end
