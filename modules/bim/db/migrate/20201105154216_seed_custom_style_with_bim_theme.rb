#-- encoding: UTF-8



# This migration cleans up messed up themes. Sometimes in the past
# the BIM theme was not set where it should have been set.
class SeedCustomStyleWithBimTheme < ActiveRecord::Migration[6.0]
  def up
    # When
    #   migrating BIM instances
    #     that did not have any custom styles OR
    #       that do not have any design colors set and no custom logo/touch-icon/favicon
    #       (this basically means that no theme actually got applied)
    # then
    #   add a custom style with the BIM theme set. This will write the theme's colors
    #   as DesignColor entries to the DB which is necessary for the theme to actually
    #   have an effect.
    if ProyeksiApp::Configuration.bim? &&
       (CustomStyle.current.nil? ||
           (DesignColor.count == 0 &&
               CustomStyle.current.favicon.nil? &&
               CustomStyle.current.logo.nil? &&
               CustomStyle.current.touch_icon.nil?))
      seed_bim_theme
    end
  end

  def down
    # nop
  end

  private

  def seed_bim_theme
    CustomStyle.transaction do
      set_custom_style
      set_design_colors
    end
  end

  def set_design_colors
    # There should not be any DesignColors present. However, we want to make sure.
    DesignColor.delete_all

    theme[:colors].each do |param_variable, param_hexcode|
      DesignColor.create variable: param_variable, hexcode: param_hexcode
    end
  end

  def set_custom_style
    custom_style = (CustomStyle.current || CustomStyle.create!)
    custom_style.attributes = { theme: theme[:theme], theme_logo: theme[:logo] }
    custom_style.save!
    custom_style
  end

  def theme
    {
      theme: 'ProyeksiApp BIM',
      colors: {
        'primary-color' => "#3270DB",
        'primary-color-dark' => "#163473",
        'alternative-color' => "#349939",
        'header-bg-color' => "#05002C",
        'header-item-bg-hover-color' => "#163473",
        'content-link-color' => "#275BB5",
        'main-menu-bg-color' => "#0E2045",
        'main-menu-bg-selected-background' => "#3270DB",
        'main-menu-bg-hover-background' => "#163473"
      },
      logo: 'bim/logo_proyeksiapp_bim_big.png'
    }
  end
end
