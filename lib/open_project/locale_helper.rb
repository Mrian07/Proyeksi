#-- encoding: UTF-8



module OpenProject
  module LocaleHelper
    def with_locale_for(user)
      previous_locale = I18n.locale
      previous_zone = Time.zone
      Time.zone = user.time_zone if user.time_zone
      SetLocalizationService.new(user).call
      yield
    ensure
      I18n.locale = previous_locale
      Time.zone = previous_zone
    end

    module_function :with_locale_for
  end
end
