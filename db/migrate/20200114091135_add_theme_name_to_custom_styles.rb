class AddThemeNameToCustomStyles < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_styles,
               :theme,
               :string,
               default: ProyeksiApp::CustomStyles::ColorThemes::DEFAULT_THEME_NAME
  end
end
