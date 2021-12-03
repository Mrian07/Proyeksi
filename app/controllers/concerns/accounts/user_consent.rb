##
# Intended to be used by the AccountController to implement the user consent
# check.
module Accounts::UserConsent
  include ::UserConsentHelper

  def consent
    if consent_required?
      render 'account/consent', locals: { consenting_user: consenting_user }
    else
      consent_finished
    end
  end

  def confirm_consent
    user = consenting_user

    if user.present? && consent_param?
      approve_consent!(user)
    else
      reject_consent!
    end
  end

  def consent_required?
    # Ensure consent is enabled and a text is provided
    return false unless user_consent_required?

    # Require the user to consent if he hasn't already
    consent_expired?
  end

  def decline_consent
    message = I18n.t('consent.decline_warning_message') + "\n"
    message <<
      if Setting.consent_decline_mail.present?
        I18n.t('consent.contact_this_mail_address', mail_address: Setting.consent_decline_mail)
      else
        I18n.t('consent.contact_your_administrator')
      end

    flash[:error] = message
    redirect_to authentication_stage_failure_path :consent
  end

  def consent_expired?
    consented_at = consenting_user.try(:consented_at)

    # Always if the user has not consented
    return true if consented_at.blank?

    # Did not expire if no consent_time set, but user has consented at some point
    return false if Setting.consent_time.blank?

    # Otherwise, expires when consent_time is newer than last consented_at
    consented_at < Setting.consent_time
  end

  def consenting_user
    User.find_by id: session[:authenticated_user_id]
  end

  def approve_consent!(user)
    user.update_column(:consented_at, DateTime.now)
    consent_finished
  end

  def consent_finished
    redirect_to authentication_stage_complete_path(:consent)
  end

  def reject_consent!
    flash[:error] = I18n.t('consent.failure_message')
    redirect_to authentication_stage_failure_path :consent
  end
end
