

require 'support/pages/page'

module Pages
  ##
  # Use this in other Pages to fill in a bunch of fields in a form.
  # You just declare all fields to be filled in and if they are given in the fields hash.
  #
  # Example:
  #     fields = { first_name: 'Billy', last_name: 'Bland', subscribe: true }
  #     form = FormFiller.new fields
  #
  #     # declare form data
  #     form.fill_in! 'Vorname', :first_name
  #     form.fill_in! 'Nachname', :last_name
  #     form.tick! 'Newsletter', :subscribe
  #     form.select! 'Geschlecht', :gender
  #
  # The declaration section maps labels and types of input fields to field names.
  # Only the fields given to the FormFiller will actually be filled in.
  # Meaning that in this example all but the gender will be filled in.
  #
  class FormFiller < Page
    attr_reader :fields

    ##
    # Creates a new FormFiller with the given fields.
    #
    # @param fields [Hash] Arbitrary keys mapped to field values to be filled in.
    def initialize(fields)
      @fields = fields
    end

    ##
    # Fills in a text field.
    def fill!(field, key)
      fill_in field, with: fields[key] if fields.include? key
    end

    ##
    # Checks (or unchecks) a check box.
    def set_checked!(field, key)
      if fields.include? key
        checked = fields[field]

        if checked
          check field
        else
          uncheck field
        end
      end
    end

    def select!(field, key)
      if fields.include? key
        select fields[key], from: field
      end
    end
  end
end
