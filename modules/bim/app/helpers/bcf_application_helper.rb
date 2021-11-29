

module BcfApplicationHelper
  def body_css_classes
    classes = super
    classes + " bcf-#{@project&.module_enabled?(:bim) ? 'activated' : 'deactivated'}"
  end
end
