#-- encoding: UTF-8



module CoreExtensions
  module String
    def to_bool
      ActiveRecord::Type::Boolean.new.deserialize downcase.strip
    end

    ##
    # Use Stringex#to_url to create a localizable slug
    # that is not dynamically supported in the upstream to_url.
    def to_localized_slug(locale: I18n.locale, **options)
      previous_locale = Stringex::Localization.locale

      begin
        Stringex::Localization.locale = locale

        to_url(options)
      ensure
        Stringex::Localization.locale = previous_locale
      end
    end
  end
end
