#-- encoding: UTF-8

module AccessibilityHelper
  def you_are_here_info(condition = true, disabled = nil)
    if condition && !disabled
      "<span style = 'display: block' class = 'position-label hidden-for-sighted'>#{I18n.t(:description_current_position)}</span>".html_safe
    elsif condition && disabled
      "<span style = 'display: none' class = 'position-label hidden-for-sighted'>#{I18n.t(:description_current_position)}</span>".html_safe
    else
      ''
    end
  end

  def empty_element_tag
    @empty_element_tag ||= ApplicationController.new.render_to_string(partial: 'accessibility/empty_element_tag').html_safe
  end

  # Returns the locale :en for the given menu item if the user locale is
  # different but equals the English translation
  #
  # Returns nil if user locale is :en (English) or no translation is given,
  # thus, assumes English to be the default language. Returns :en iff a
  # translation exists and the translation equals the English one.
  def menu_item_locale(menu_item)
    return nil if english_locale_set?

    caption_content = menu_item.instance_variable_get(:@caption)
    locale_label = caption_content.is_a?(Symbol) ? caption_content : :"label_#{menu_item.name}"

    !locale_exists?(locale_label) || equals_english_locale(locale_label) ? :en : nil
  end

  private

  def locale_exists?(key, locale = I18n.locale)
    I18n.t(key, locale: locale, raise: true)
  rescue StandardError
    false
  end

  def english_locale_set?
    I18n.locale == :en
  end

  def equals_english_locale(key)
    key.is_a?(Symbol) ? (I18n.t(key) == I18n.t(key, locale: :en)) : false
  end
end
