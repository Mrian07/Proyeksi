#-- encoding: UTF-8



module CustomStylesHelper
  def apply_custom_styles?(skip_ee_check: ProyeksiApp::Configuration.bim?)
    # Apply custom styles either if EE allows OR we are on a BIM edition with the BIM theme active.
    CustomStyle.current.present? &&
      (EnterpriseToken.allows_to?(:define_custom_style) || skip_ee_check)
  end

  # The default favicon and touch icons are both the same for normal OP and BIM.
  def apply_custom_favicon?
    apply_custom_styles?(skip_ee_check: false) && CustomStyle.current.favicon.present?
  end

  # The default favicon and touch icons are both the same for normal OP and BIM.
  def apply_custom_touch_icon?
    apply_custom_styles?(skip_ee_check: false) && CustomStyle.current.touch_icon.present?
  end
end
