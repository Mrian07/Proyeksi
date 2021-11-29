#-- encoding: UTF-8



module ::UserConsentHelper
  def consent_param?
    params[:consent_check].present?
  end

  def user_consent_required?
    # Ensure consent is enabled and a text is provided
    Setting.consent_required? && consent_configured?
  end

  ##
  # Gets consent instructions for the given user.
  #
  # @param user [User] The user to get instructions for.
  # @param locale [String] ISO-639-1 code for the desired locale (e.g. de, en, fr).
  #                        `I18n.locale` is set for each request individually depending
  #                        among other things on the user's Accept-Language headers.
  # @return [String] Instructions in the respective language.
  def user_consent_instructions(_user, locale: I18n.locale)
    all = Setting.consent_info

    all.fetch(locale) { all.values.first }
  end

  def consent_checkbox_label(locale: I18n.locale)
    I18n.t('consent.checkbox_label', locale: locale)
  end

  def consent_configured?
    if Setting.consent_info.count == 0
      Rails.logger.error 'Instance is configured to require consent, but no consent_info has been set.'

      false
    else
      true
    end
  end
end
