#-- encoding: UTF-8



module ProyeksiApp::CustomStyles
  class ColorThemes
    ProyeksiApp::CustomStyles::ColorThemes::DEFAULT_THEME_NAME = 'ProyeksiApp'.freeze

    THEMES = [
      {
        theme: ProyeksiApp::CustomStyles::ColorThemes::DEFAULT_THEME_NAME,
        colors: {
          'primary-color' => "#1A67A3",
          'primary-color-dark' => "#175A8E",
          'alternative-color' => "#35C53F",
          'content-link-color' => "#175A8E",
          'header-bg-color' => "#1A67A3",
          'header-item-bg-hover-color' => "#175A8E",
          'header-item-font-color' => "#FFFFFF",
          'header-item-font-hover-color' => "#FFFFFF",
          'header-border-bottom-color' => "",
          'main-menu-bg-color' => "#333739",
          'main-menu-bg-selected-background' => "#175A8E",
          'main-menu-bg-hover-background' => "#124E7C",
          'main-menu-font-color' => "#FFFFFF",
          'main-menu-hover-font-color' => "#FFFFFF",
          'main-menu-selected-font-color' => "#FFFFFF",
          'main-menu-border-color' => "#EAEAEA"
        }
      },
      {
        theme: 'ProyeksiApp Light',
        colors: {
          'primary-color' => "#1A67A3",
          'primary-color-dark' => "#175A8E",
          'alternative-color' => "#138E1B",
          'content-link-color' => "#175A8E",
          'header-bg-color' => "#FAFAFA",
          'header-item-bg-hover-color' => "#E1E1E1",
          'header-item-font-color' => "#313131",
          'header-item-font-hover-color' => "#313131",
          'header-border-bottom-color' => "#E1E1E1",
          'main-menu-bg-color' => "#ECECEC",
          'main-menu-bg-selected-background' => "#A9A9A9",
          'main-menu-bg-hover-background' => "#FFFFFF",
          'main-menu-font-color' => "#000000",
          'main-menu-hover-font-color' => "#000000",
          'main-menu-selected-font-color' => "#000000",
          'main-menu-border-color' => "#EAEAEA"
        },
        logo: 'logo_proyeksiapp.png'
      },
      {
        theme: 'ProyeksiApp Dark',
        colors: {
          'primary-color' => "#3270DB",
          'primary-color-dark' => "#163473",
          'alternative-color' => "#349939",
          'content-link-color' => "#275BB5",
          'header-bg-color' => "#05002C",
          'header-item-bg-hover-color' => "#163473",
          'header-item-font-color' => "#FFFFFF",
          'header-item-font-hover-color' => "#FFFFFF",
          'header-border-bottom-color' => "",
          'main-menu-bg-color' => "#0E2045",
          'main-menu-bg-selected-background' => "#3270DB",
          'main-menu-bg-hover-background' => "#163473",
          'main-menu-font-color' => "#FFFFFF",
          'main-menu-hover-font-color' => "#FFFFFF",
          'main-menu-selected-font-color' => "#FFFFFF",
          'main-menu-border-color' => "#EAEAEA"
        }
      }
    ].freeze

    def self.themes
      THEMES
    end
  end
end
