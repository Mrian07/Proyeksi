#-- encoding: UTF-8



module PasswordHelper
  include PasswordConfirmation

  ##
  # Decorate the form_for helper with the request-for-confirmation directive
  # when the user is internally authenticated.
  def password_confirmation_form_for(record, options = {}, &block)
    if password_confirmation_required?
      options.reverse_merge!(html: {})
      data = options[:html].fetch(:data, {})
      options[:html][:data] = password_confirmation_data_attribute(data)
    end

    form_for(record, options, &block)
  end

  ##
  # Decorate the form_tag helper with the request-for-confirmation directive
  # when the user is internally authenticated.
  def password_confirmation_form_tag(url_for_options = {}, options = {}, &block)
    if password_confirmation_required?
      data = options.fetch(:data, {})
      options[:data] = password_confirmation_data_attribute(data)
    end

    form_tag(url_for_options, options, &block)
  end

  def password_confirmation_data_attribute(with_data = {})
    if password_confirmation_required?
      with_data.merge('request-for-confirmation': true)
    else
      with_data
    end
  end

  def render_password_complexity_hint
    rules = password_rules_description

    s = ProyeksiApp::Passwords::Evaluator.min_length_description
    s += "<br> #{rules}" if rules.present?

    s.html_safe
  end

  private

  # Return a HTML list with active password complexity rules
  def password_active_rules
    rules = ProyeksiApp::Passwords::Evaluator.active_rules_list
    content_tag :ul do
      rules.map { |item| concat(content_tag(:li, item)) }
    end
  end

  # Returns a text describing the active password complexity rules,
  # the minimum number of rules to adhere to and the total number of rules.
  def password_rules_description
    return '' if ProyeksiApp::Passwords::Evaluator.min_adhered_rules == 0

    ProyeksiApp::Passwords::Evaluator.rules_description_locale(password_active_rules)
  end
end
