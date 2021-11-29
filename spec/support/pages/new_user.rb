

require 'support/pages/page'

module Pages
  class NewUser < Page
    def path
      '/users/new'
    end

    ##
    # Fills in the given user form fields.
    def fill_in!(fields = {})
      form = FormFiller.new fields

      form.fill! 'First name', :first_name
      form.fill! 'Last name', :last_name
      form.fill! 'Email', :email

      form.select! 'Authentication mode', :auth_source
      form.fill! 'Username', :login

      form.set_checked! 'Administrator', :admin
    end

    def submit!
      click_button 'Create'
    end
  end
end
